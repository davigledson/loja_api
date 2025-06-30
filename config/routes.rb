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
      resources :pedidos do
        collection do
          # Rota para listar pedidos de um usuário específico
          get 'usuario/:usuario_id', to: 'pedidos#index_by_user'
          # NOVAS ROTAS PARA O DASHBOARD
          get 'contar', to: 'pedidos#contar_pedidos'
          get 'contar_por_status', to: 'pedidos#contar_pedidos_por_status'
          get 'faturamento_total', to: 'pedidos#faturamento_total'
          get 'faturamento_mes_atual', to: 'pedidos#faturamento_mes_atual'
          get 'produtos_mais_vendidos', to: 'pedidos#produtos_mais_vendidos'
          get 'vendas_recentes', to: 'pedidos#vendas_recentes'
        end
        # Se você tiver outras ações personalizadas para pedidos, adicione aqui
      end
      resources :favoritos do 
        collection do
          # Rota para listar favoritos de um usuário específico
          # GET /api/v1/favoritos/usuario/:usuario_id
          get 'usuario/:usuario_id', to: 'favoritos#index_by_user'
        end
     
      end
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
