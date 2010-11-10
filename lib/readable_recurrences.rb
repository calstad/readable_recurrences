require "date"

module ReadableRecurrences

  def self.find(dates)
    match_recurrences(dates)
  end

  #sorts the days of the month into a nested hash based on year then month then
  #day of week
  def self.sort_dates(dates)
    parsed_dates = parse_dates(dates)
    date_hasher = lambda {|h, k| h[k] = Hash.new(&date_hasher)}
    
    parsed_dates.inject(Hash.new(&date_hasher)) do |hsh, d|
      if hsh[d.year][d.month][d.wday].kind_of?(Array)
        hsh[d.year][d.month][d.wday] << d.day
      else
        hsh[d.year][d.month][d.wday] = [d.day]
      end
      hsh
    end
  end

  #parses the array of strings into Date objects
  def self.parse_dates(dates)
    dates.inject([]) {|arr, s| arr << Date.parse(s); arr;}
  end

  def self.match_recurrences(dates)
    sorted_dates = sort_dates(dates)
        
    match_weekly(sorted_dates)
  end

  def self.match_weekly(sorted_dates)
    matches = []
    sorted_dates.keys.each do |year|
      sorted_dates[year].keys.each do |month|
        sorted_dates[year][month].keys.each do |weekday|
          if sorted_dates[year][month][weekday].size == days_of_week_count_for_month(month, year, weekday)
            matches << "All #{Date::DAYNAMES[weekday]}s in #{Date::MONTHNAMES[month]} #{year}"
          end
        end
      end
    end
    matches
  end

  def self.days_of_week_count_for_month(month, year, day_of_week)
    start_date = Date.civil(year, month, 1)
    end_date = Date.civil(year, month, -1)
    count = 0
    while end_date > start_date
      count += 1 if start_date.wday == day_of_week
      start_date = Date.civil(year, month, start_date.day + 1)
    end
    count
  end
  
end