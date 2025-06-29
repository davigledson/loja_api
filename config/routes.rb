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
     
      resources :enderecos do
        collection do
          # Rota para listar endereços de um usuário específico
          # GET /api/v1/enderecos/usuario/:usuario_id
          get 'usuario/:usuario_id', to: 'enderecos#index_by_user'
        end
        member do
          # Rota para definir um endereço como principal
          # PATCH /api/v1/enderecos/:id/principal
          patch 'principal', to: 'enderecos#set_principal'
        end
      end
       resources :carrinhos do
        collection do
          get 'usuario/:usuario_id', to: 'carrinhos#buscar_por_usuario'
        end
        member do
          delete 'limpar', to: 'carrinhos#limpar'
        end
      end

      resources :itens_carrinho do
        collection do
          # Rota para listar itens de um carrinho específico
          # GET /api/v1/itens_carrinho/carrinho/:carrinho_id
          get 'carrinho/:carrinho_id', to: 'itens_carrinho#index_by_cart'
        end
      end
      resources :favoritos
      resources :carrinhos
      resources :itens_carrinho
      resources :itens_pedido
    end
  end
end
