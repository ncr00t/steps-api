Rails.application.routes.draw do
  resources :users, param: :name
  post '/auth/login', to: 'authentication#login'
  post '/users/:name', to: 'users#set_steps'
  get '/*a', to: 'application#not_found'
end
