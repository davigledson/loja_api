Rails.application.routes.draw do
  devise_for :usuarios, path: 'api/v1/auth', controllers: {
    registrations: 'api/v1/auth/registrations',
    sessions: 'api/v1/auth/sessions'
  }

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :clientes
      resources :usuarios
      resources :produtos
      resources :categorias
      resources :pedidos
      resources :enderecos
      resources :favoritos
      resources :carrinhos
      resources :itens_carrinho
      resources :itens_pedido
    end
  end
end
