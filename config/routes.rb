RailsSso::Engine.routes.draw do
  scope module: 'rails_sso' do
    get '/:provider/callback', to: 'sessions#create'
    delete '/sign_out', to: 'sessions#destroy', as: :sign_out

    root to: redirect("/auth/#{RailsSso.provider_name}"), as: :sign_in
  end
end
