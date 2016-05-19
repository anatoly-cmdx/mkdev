module Home
  class HomeController < Home::BaseController
    respond_to :html, :js

    def index
      @card = if params[:id]
                current_user.cards.find(params[:id])
              else
                current_user.first_pending_or_repeating_card
              end

      respond_with @card
    end
  end
end
