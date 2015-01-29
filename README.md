# SSO client Rails Engine

[![Dependency Status](https://gemnasium.com/monterail/rails_sso.svg)](https://gemnasium.com/monterail/rails_sso)
[![Gem Version](https://badge.fury.io/rb/rails_sso.svg)](http://badge.fury.io/rb/rails_sso)

## About

*SOON*

## Installation

Add engine and [omniauth](https://github.com/intridea/omniauth-oauth2) provider gems to your project:

```ruby
# Gemfile

gem 'omniauth-example'
gem 'rails_sso'
```

Configure it:

```ruby
# conifg/initializers/sso.rb

RailsSso.configure do |config|
  # name of oauth2 provider
  config.provider_name = 'example'
  # oauth keys for omniauth-example
  config.provider_key = ENV['PROVIDER_KEY']
  config.provider_secret = ENV['PROVIDER_SECRET']
  # path for fetching user data
  config.provider_profile_path = '/api/v1/profile'
  # set if you support single sign out
  config.provider_sign_out_path = '/api/v1/session'
  # enable cache (will use Rails.cache store)
  config.use_cache = Rails.application.config.action_controller.perform_caching

  # user fields to synchronize from API
  config.user_fields = [
    :email,
    :name,
    :roles
  ]

  # user repository class name
  config.user_repository = 'UserRepository'
end
```

And mount it:

```ruby
# config/routes.rb

Rails.application.routes.draw do
  mount RailsSso::Engine => '/sso', as: 'sso'
end
```

## Usage

Available helpers for controllers and views:

* `current_user`
* `user_signed_in?`

Available filters and helpers for controllers:

* `authenticate_user!`
* `save_access_token!`
* `invalidate_access_token!`

Available helpers for views:

* `sso.sign_in_path`
* `sso.sign_out_path`

## User Repository

Required methods:

* `find_by_sso_id(id)`
* `create_with_sso_id(id, attrs)`
* `update(record, attrs)`

Example with `ActiveRecord` user model:

```ruby
# app/repositories/user_repository.rb

class UserRepository
  attr_accessor :adapter

  def initialize(adapter = User)
    self.adapter = adapter
  end

  def find_by_sso_id(id)
    adapter.find_by(sso_id: id)
  end

  def create_with_sso_id(id, attrs)
    adapter.new(attrs) do |user|
      user.sso_id = id
      user.save!
    end
  end

  def update(record, attrs)
    adapter.update(record.id, attrs)
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
