class BetsController < ApplicationController
  def edit
    render locals: { bet: Bet.find(params[:id]),
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
    form.save
    redirect_to root_path
  end

  def create
    bet = Bet.new
    form = BetForm.new(bet,
                       params[:bet].merge(user_id: current_user.id,
                                          football_match_id: params[:football_match_id]))
    form.save
    redirect_to root_path
  end

  def destroy
    bet = Bet.find(params[:id])
    bet.destroy
    redirect_to root_path
  end
end
