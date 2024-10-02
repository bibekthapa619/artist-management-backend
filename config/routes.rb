Rails.application.routes.draw do
  scope 'api', defaults: { format: :json } do

    scope 'users' do
      get '/', to: 'users#index'
      get '/:id', to: 'users#show'
      put '/:id', to: 'users#update'
      delete '/:id', to: 'users#destroy'
      post '/', to: 'users#create'
    end 

    scope 'auth' do
      post '/login', to: 'auth#login'
      post '/register', to: 'auth#register'
      post '/logout', to: 'auth#logout'
      get '/me', to: 'auth#me'
    end

  end

end
