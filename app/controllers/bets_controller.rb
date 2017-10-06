class BetsController < ApplicationController
  def edit
    render locals: { bet: bet,
                     football_match: FootballMatch.find(params[:football_match_id])}
  end

  def new
    render locals: { bet: Bet.new,
                     football_match: FootballMatch.find(params[:football_match_id])}
  end

  def update
    bet = Bet.find(params[:id])
    form = BetForm.new(bet,
                       params[:bet].merge(user_id: current_user.id,
                                          football_match_id: params[:football_match_id]))
    if form.save
      redirect_to root_path, notice: 'Bet succesfully updated'
    else
      flash[:alert] = 'Could not update bet'
      render 'edit'
    end
  end

  def create
    bet = Bet.new
    form = BetForm.new(bet,
                       params[:bet].merge(user_id: current_user.id,
                                          football_match_id: params[:football_match_id]))
    if form.save
      redirect_to root_path, notice: 'Bet succesfully created'
    else
      flash[:alert] = 'Could not create bet'
      render 'new'
    end
  end

  def destroy
    bet = Bet.find(params[:id])
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
end
