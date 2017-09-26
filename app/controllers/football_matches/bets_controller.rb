module FootballMatches
  class BetsController < ApplicationController
    def edit
      authorize [football_match, bet]
      render locals: {
        form: BetForm.new(bet, {}),
        football_match: football_match
      }
    end

    def new
      authorize [football_match, Bet]

      render locals: {
        form: BetForm.new(Bet.new, {}),
        football_match: football_match
      }
    end

    def update
      authorize [football_match, bet]

      form = BetForm.new(
        bet,
        params[:bet].merge(
          user_id: current_user.id,
          football_match_id: params[:football_match_id]
        )
      )
      if form.save
        redirect_to root_path, notice: 'Bet successfully updated'
      else
        flash[:error] = 'Could not update bet'
        render 'edit', locals: {
          form: form,
          football_match: football_match
        }
      end
    end

    def create
      authorize [football_match, Bet]

      form = BetForm.new(
        Bet.new,
        params[:bet].merge(
          user_id: current_user.id,
          football_match_id: params[:football_match_id]
        )
      )
      if form.save
        redirect_to root_path, notice: 'Bet successfully created'
      else
        flash[:error] = 'Could not create bet'
        render 'new', locals: {
          form: form,
          football_match: football_match
        }
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

    def bet
      @bet ||= Bet.find(params[:id])
    end

    def football_match
      @football_match ||= FootballMatch.find(params[:football_match_id])
    end
  end
end
