module Dashboard
  class TrainersController < Dashboard::BaseController
    respond_to :html, :js, only: :show

    before_action :find_card

    def show
      @card ||= current_user.first_pending_or_repeating_card
      respond_with @card
    end

    def review_card
      check_result = @card.check_translation(user_translation)

      if check_result[:state]
        if check_result[:distance] == 0
          flash[:notice] = t :correct_translation_notice
        else
          flash[:alert] = misprint_alert_text
        end
        redirect_to trainer_path
      else
        flash[:alert] = t :incorrect_translation_alert
        redirect_to trainer_path(card_id: @card)
      end
    end

    private

    def find_card
      @card = current_user.cards.find(params[:card_id]) if params[:card_id]
    end

    def trainer_params
      params.permit(:user_translation)
    end

    def misprint_alert_text
      t :translation_from_misprint_alert,
        user_translation: user_translation,
        original_text: @card.original_text,
        translated_text: @card.translated_text
    end

    def user_translation
      trainer_params[:user_translation]
    end
  end
end
