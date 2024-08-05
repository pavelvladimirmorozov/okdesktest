Rails.application.routes.draw do
  resource :session, only: %i[new create destroy]

  resources :users, only: %i[new create edit update]

  resources :uploaded_files, only: %i[index show create]
  
  root "pages#index"
end
