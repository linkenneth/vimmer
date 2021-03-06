Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'pages#landing'

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  resources :posts, except: [:new, :edit] do
    post 'like'
  end

  resources :follows, except: [:new, :edit]
end
