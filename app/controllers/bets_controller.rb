class BetsController < ApplicationController
  def edit
    render locals: { form: BetForm.new(bet, {}),
                     football_match: football_match }
  end

  def new
    render locals: { form: BetForm.new(Bet.new, {}),
                     football_match: football_match }
  end

  def update
    form = BetForm.new(bet,
                       params[:bet].merge(user_id: current_user.id,
                                          football_match_id: params[:football_match_id]))
    if form.save
      redirect_to root_path, notice: 'Bet succesfully updated'
    else
      flash[:error] = 'Could not update bet'
      render 'edit', locals: { form: form,
                               football_match: football_match }
    end
  end

  def create
    form = BetForm.new(Bet.new,
                       params[:bet].merge(user_id: current_user.id,
                                          football_match_id: params[:football_match_id]))
    if form.save
      redirect_to root_path, notice: 'Bet succesfully created'
    else
      flash[:error] = 'Could not create bet'
      render 'new', locals: { form: form,
                              football_match: football_match }
    end
  end

  def destroy
    if bet.destroy
      redirect_to root_path, notice: 'Bet succesfully deleted'
    else
      redirect_to root_path, alert: 'Bet succesfully deleted'
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
