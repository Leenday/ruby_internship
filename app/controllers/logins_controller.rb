class LoginsController < ApplicationController
    def show
    end
  
    def create
    # raise if params[:password] != '123'

    #     session[:login] = params[:login]
    #     redirect_to :login, notice: 'Вы вошли'
    # rescue
    #     redirect_to :login, notice: 'Неверный пароль'
    # end

        login_service = LoginService.new(params[:login], params[:password], session)
        redirect_to :login, notice: login_service.message

    end


    #   if params[:password] == '123'
    #     session[:login] = params[:login]
    #     redirect_to :login, notice: 'Вы вошли'
    #   else
        # redirect_to :login, notice: 'Неверный пароль'
    #   end
    # end
  
    def destroy
      session.delete(:login)
      redirect_to :login, notice: 'Вы вышли'
    end
  end
  