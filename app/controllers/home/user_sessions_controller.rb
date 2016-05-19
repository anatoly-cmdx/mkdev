module Home
  class UserSessionsController < Home::BaseController
    def new
      if current_user
        redirect_to root_path
      else
        @user = User.new
      end
    end

    def create
      @user = login(params[:email], params[:password])
      if @user
        redirect_back_or_to root_path, notice: t(:log_in_is_successful_notice)
      else
        flash.now[:alert] = t(:not_logged_in_alert)
        render action: 'new'
      end
    end
  end
end
