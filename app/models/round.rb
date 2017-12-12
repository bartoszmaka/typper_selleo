class Round < ApplicationRecord
  paginates_per 1
  DEFAULT_PAGE = Round.page.total_pages.freeze

  has_many :football_matches
  has_many :bets, through: :football_matches
  has_many :away_team, class_name: Team.name, through: :football_matches
  has_many :home_team, class_name: Team.name, through: :football_matches
  has_many :users, through: :bets

  scope :current_round_id, -> { joins(:football_matches)
                                .find_by('football_matches.match_date > ?', Time.now)&.id || DEFAULT_PAGE }

  def user_score(user_id)
    bets.where(user_id: user_id).sum(:point)
  end

  def self.current_page
    default_page = DEFAULT_PAGE
    1.upto Round.page.total_pages do |page_number|
      default_page = page_number if Round.page(page_number).include?(Round.find(current_round_id))
    end
    default_page
  end

  def winner
    users.select('users.*',
                 'SUM(bets.point) AS round_points',
                 'COUNT(bets.id) FILTER (WHERE bets.point = 3) AS number_of_correct_bets',
                 'SUM(ABS(bets.home_team_score - football_matches.home_team_score) + ' \
                   'ABS(bets.away_team_score - football_matches.away_team_score)) AS goal_difference')
         .group(:id)
         .order('round_points DESC', 'number_of_correct_bets DESC', 'goal_difference ASC')
         .first
  end
end
