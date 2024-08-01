Rails.application.routes.draw do
  resources :users, only: %i[new create]

  resources :uploaded_files, only: %i[index show create]
  
  root "uploaded_files#index"
end
