class GrapeApi     
  class UsersApi < Grape::API # rubocop:disable Metrics/ClassLength
    format :json

      namespace :users do      

        params do
          optional :balance, type: Integer
        end
        get do
          users = if params[:balance].present?
            User.where('balance >= :balance', balance: params[:balance])
          else
            User.all
          end
          present users
        end



      route_param :id, type: Integer do
          get do
            user = User.find_by_id(params[:id])
            error!({ message: 'Пользователь не найден' }, 404) unless user
            present user
          end
        end 
    end
  end
end
  