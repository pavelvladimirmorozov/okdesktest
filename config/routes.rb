Rails.application.routes.draw do
  
  resources :uploaded_files, only: %i[index show create]
  root "uploaded_files#index"
end
