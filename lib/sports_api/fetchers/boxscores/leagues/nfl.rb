class SportsApi::Fetcher::Boxscore::NFL < SportsApi::Fetcher::Boxscore
  include SportsApi::Fetcher::ESPN::Scraper
  attr_accessor :event_date

  def response
    SportsApi::Model::Boxscore.new.tap do |boxscore|
      boxscore.score = generate_score
      #boxscore.score_detail = 
    end
  end

  private

  def event_date
    @event_date ||= Date.parse(markup.at_css('.game-time-location p').content)
  end

  def generate_score
    score_fetcher.events.detect do |event|
      event.gameid == gameid
    end
  end

  def score_fetcher
    @score_fetcher ||= SportsApi::Fetcher::Score::NFL.find(date_list.season, date_list.week)
  end

  def date_list
    calendar.dates.detect do |list|
      (list.start_date < event_date) && (event_date < list.end_date)
    end
  end

  def calendar
    @calendar ||= SportsApi::Fetcher::Score::NFL.find(1, 1).calendar
  end

  def markup
    @markup ||= get('nfl/boxscore', gameId: gameid)
  end
end
