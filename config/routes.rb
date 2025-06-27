Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    get "test", to: "test#index"

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
