Rails.application.routes.draw do
  scope 'api' do

    scope 'users' do
      get '/', to: 'users#index'
      get '/:id', to: 'users#show'
      post '/', to: 'users#create'
    end 

    scope 'auth' do
      post '/login', to: 'auth#login'
    end

  end

end
