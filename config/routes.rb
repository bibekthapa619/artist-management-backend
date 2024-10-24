Rails.application.routes.draw do
  scope 'api', defaults: { format: :json } do

    scope 'users', controller: :user do
      get '/', action: :index
      get '/:id', action: :show
      put '/:id', action: :update
      delete '/:id', action: :destroy
      post '/', action: :create
    end

    scope 'auth', controller: :auth do
      post '/login', action: :login
      post '/register', action: :register
      post '/logout', action: :logout
      get '/me', action: :me
    end

    scope 'artists', controller: :artist do
      get '/', action: :index
      get '/export', action: :export_csv
      post '/import', action: :import_csv 
      get '/import-sample', action: :import_sample 
      get '/:id', action: :show
      get '/:id/music', action: :music
      put '/:id', action: :update
      delete '/:id', action: :destroy
      post '/', action: :create
    end

    scope 'musics', controller: :music do
      get '/', action: :index
      get '/:id', action: :show
      put '/:id', action: :update
      delete '/:id', action: :destroy
      post '/', action: :create
    end

    scope 'dashboard', controller: :dashboard do
      get '/users', action: :get_user_stats
      get '/musics', action: :get_music_stats
    end
  
  end

end
