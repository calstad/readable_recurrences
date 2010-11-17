require "date"

module ReadableRecurrences
  extend self
  
  def find(dates)
    match_recurrences(dates)
  end

  #sorts the days of the month into a nested hash based on year then month then
  #day of week
  def sort_dates(dates)
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
  def parse_dates(dates)
    dates.inject([]) {|arr, s| arr << Date.parse(s); arr;}
  end

  #matches every week occurrences 
  def match_recurrences(dates)
    sorted_dates = sort_dates(dates)
    recurrence_schedules = []
    recurrence_schedules << match_weekly(sorted_dates)

    recurrence_schedules.join(' and ')
  end

  def match_weekly(sorted_dates)
    matches = []
    sorted_dates.keys.each do |year|
      sorted_dates[year].keys.each do |month|
        sorted_dates[year][month].keys.each do |weekday|
          dates = sorted_dates[year][month][weekday]
          if dates.size  == days_of_week_count_for_month(month, year, weekday)
            matches << "Every #{Date::DAYNAMES[weekday]} in #{Date::MONTHNAMES[month]} #{year}"
          end
        end
      end
    end
    matches
  end

  # Returns the count for a given day of the week in a given month,
  # i.e. there are 5 Tuesdays in November 2011
  def days_of_week_count_for_month(month, year, day_of_week)
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
