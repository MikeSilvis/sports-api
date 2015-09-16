require_relative '../helpers/api_parser'

class SportsApi::Fetcher::Score::NFL < SportsApi::Fetcher::Score
  include SportsApi::Fetcher::ESPN::Api
  include SportsApi::Fetcher::Score::ApiParser

  attr_accessor :season_type

  def initialize(season_type, week)
    self.week = week
    self.season_type = season_type
  end

  def self.find(date)
    date_obj = date_list(date)

    date_obj ? SportsApi::Fetcher::Score::NFL.find_by(date_obj.season, date_obj.week) : nil
  end

  def self.find_by(season_type, week)
    new(season_type, week).response
  end

  def league
    SportsApi::NFL
  end

  private

  def self.date_list(date)
    date_obj = SportsApi::Fetcher::Calendar::NFL.find.detect do |list|
      (list.start_date < date) && (date < list.end_date)
    end

    ## if no date found, try removing a day
    unless date_obj
      date = date - 1
      return SportsApi::Fetcher::Calendar::NFL.find.detect do |list|
        (list.start_date <= date) && (date <= list.end_date)
      end
    end

    date_obj
  end

  def generate_calendar(calendar_json)
    generate_calendar_list(calendar_json)
  end

  def json
    @json ||= get('football', 'nfl', week: week, seasontype: season_type)
  end
end
