module FootballMatches
  class BetsController < ApplicationController
    respond_to :html, :json

    def new
      authorize [football_match, Bet]
      @form = BetForm.new(Bet.new, {})

      respond_modal_with @form
    end

    def create
      authorize [football_match, Bet]

      @form = BetForm.new(Bet.new, bet_params)
      if @form.save
        flash[:notice] = 'Bet successfully created'
        respond_modal_with nil, location: root_path
      else
        flash[:error] = 'Could not create bet'
        respond_modal_with @form
      end
    end

    def edit
      authorize [football_match, bet]
      @form = BetForm.new(@bet, {})

      respond_modal_with @form
    end

    def update
      authorize [football_match, bet]

      @form = BetForm.new(@bet, bet_params)

      if @form.save
        flash[:notice] = 'Bet successfully updated'
        respond_modal_with nil, location: root_url
      else
        flash[:error] = 'Could not update bet'
        respond_modal_with @form
      end
    end

    def destroy
      authorize [football_match, bet]

      if bet.destroy
        redirect_to root_path, notice: 'Bet successfully deleted'
      else
        redirect_to root_path, alert: "Can't remove bet"
      end
    end

    private

    def bet_params
      params[:bet].merge(
        user_id: current_user.id,
        football_match_id: params[:football_match_id]
      )
    end

    def bet
      @bet ||= Bet.find(params[:id])
    end

    def football_match
      @football_match ||= FootballMatch.find(params[:football_match_id])
    end
  end
end
