Rails.application.routes.draw do
  root 'welcome#index'

  get 'welcome/index'

  resources :questions, only: [:index]
end
