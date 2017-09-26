# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_171_011_174_454) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'bets', force: :cascade do |t|
    t.integer 'football_match_id'
    t.integer 'user_id'
    t.integer 'home_team_score', null: false
    t.integer 'away_team_score', null: false
    t.integer 'point', default: 0
    t.index ['football_match_id'], name: 'index_bets_on_football_match_id'
    t.index ['user_id'], name: 'index_bets_on_user_id'
  end

  create_table 'football_matches', force: :cascade do |t|
    t.bigint 'away_team_id'
    t.bigint 'home_team_id'
    t.integer 'away_team_score'
    t.integer 'home_team_score'
    t.datetime 'match_date', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'round_id'
    t.index ['away_team_id'], name: 'index_football_matches_on_away_team_id'
    t.index ['home_team_id'], name: 'index_football_matches_on_home_team_id'
  end

  create_table 'rounds', force: :cascade do |t|
    t.integer 'year'
    t.integer 'number'
  end

  create_table 'teams', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.datetime 'remember_created_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
  end

  add_foreign_key 'football_matches', 'teams', column: 'away_team_id'
  add_foreign_key 'football_matches', 'teams', column: 'home_team_id'
end
