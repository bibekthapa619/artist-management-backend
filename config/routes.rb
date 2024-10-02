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

    scope 'artists' do
      get '/', to: 'artist#index'
      get '/:id', to: 'artist#show'
      put '/:id', to: 'artist#update'
      delete '/:id', to: 'artist#destroy'
      post '/', to: 'artist#create'
    end 

    scope 'musics' do
      get '/', to: 'music#index'
      get '/:id', to: 'music#show'
      put '/:id', to: 'music#update'
      delete '/:id', to: 'music#destroy'
      post '/', to: 'music#create'
    end 

  end

end
