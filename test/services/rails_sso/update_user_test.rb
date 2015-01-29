require 'anima'
require 'test_helper'

class RailsSso::UpdateUserTest < ActiveSupport::TestCase
  class User
    include Anima.new('email', 'name')

    attr_accessor :id
    attr_writer :name, :email
  end

  class Repository
    attr_reader :storage

    def initialize
      @storage = {}
    end

    def find_by_sso_id(id)
      storage[id]
    end

    def create_with_sso_id(id, data)
      @storage[id] = User.new(data).tap do |user|
        user.id = id
      end
    end

    def update(user, params)
      params.each do |k, v|
        user.send("#{k}=", v)
      end
    end
  end

  def setup
    @repository = Repository.new

    @options = {
      repository: @repository,
      fields: [:name, :email]
    }

    @data = {
      'id' => 1,
      'name' => 'Kowalski',
      'email' => 'jan@kowalski.pl',
      'key' => 'value'
    }
  end

  test "call should create user if not exists in repository and return it" do
    output = RailsSso::UpdateUser.new(@data, @options).call

    assert_equal_user(@data, output)

    user = @repository.find_by_sso_id(@data['id'])

    assert_equal_user(@data, user)
  end

  test "call should update user if exists in repository and return it" do
    @repository.create_with_sso_id(@data['id'], { 'email' => 'test@example.com', 'name' => 'Nowak' })

    output = RailsSso::UpdateUser.new(@data, @options).call

    assert_equal_user(@data, output)

    user = @repository.find_by_sso_id(@data['id'])

    assert_equal_user(@data, user)
  end

  def assert_equal_user(data, user)
    assert_equal data['id'], user.id
    assert_equal data['email'], user.email
    assert_equal data['name'], user.name
  end
end
