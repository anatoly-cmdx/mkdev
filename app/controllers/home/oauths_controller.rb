module Home
  class OauthsController < Home::BaseController
    # sends the user on a trip to the provider,
    # and after authorizing there back to the callback url.
    def oauth
      login_at(auth_params[:provider])
    end

    def callback
      provider = auth_params[:provider]
      provider_name = provider.titleize

      if login_from provider
        redirect_to trainer_path,
                    notice: t('log_in_is_successful_provider_notice', provider: provider_name)
      elsif create_user_from_provider provider
        redirect_to trainer_path,
                    notice: t('log_in_is_successful_provider_notice', provider: provider_name)
      else
        redirect_to user_sessions_path,
                    alert: t('log_out_failed_provider_alert', provider: provider_name)
      end
    end

    private

    def create_user_from_provider(provider)
      user = create_from(provider)
      reset_session
      auto_login user
      user
    rescue
      nil
    end

    def auth_params
      params.permit(:code, :provider)
    end
  end
end
