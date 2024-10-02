Rails.application.routes.draw do
  scope 'api', defaults: { format: :json } do

    scope 'users' do
      get '/', to: 'user#index'
      get '/:id', to: 'user#show'
      put '/:id', to: 'user#update'
      delete '/:id', to: 'user#destroy'
      post '/', to: 'user#create'
    end 

    scope 'auth' do
      post '/login', to: 'auth#login'
      post '/register', to: 'auth#register'
      post '/logout', to: 'auth#logout'
      get '/me', to: 'auth#me'
    end

  end

end
