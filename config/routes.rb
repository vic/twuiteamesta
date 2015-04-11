Rails.application.routes.draw do
  
  root to: 'welcome#index'
  
  namespace :api do
    post 'create' => 'statuses#create'    
    get 'fetch/:username' => 'statuses#fetch'
    get 'subscribe/:username' => 'statuses#subscribe'
  end


end
