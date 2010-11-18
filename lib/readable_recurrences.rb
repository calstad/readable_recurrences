require "date"

module ReadableRecurrences
  extend self
  
  def find(dates)
    match_recurrences(dates)
  end

  #sorts the days of the month into a nested hash based on year then month then
  #day of week
  def sort_dates(parsed_dates)
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

  def match_recurrences(dates)
    parsed_dates = parse_dates(dates)
    sorted_dates = sort_dates(parsed_dates)
    
    recurrence_schedules = []
    recurrence_schedules += match_weekly(sorted_dates)
    if recurrence_schedules.empty?
      recurrence_schedules += match_first_and_third(sorted_dates)
      recurrence_schedules += match_second_and_fourth(sorted_dates)
    end

    recurrence_schedules.join(' and ')
  end

  #matches every week occurrences 
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

  def match_first_and_third(sorted_dates)
    matches = []
    sorted_dates.keys.each do |year|
      sorted_dates[year].keys.each do |month|
        sorted_month = sort_dates(all_dates_in_month(month, year))[year][month]
        sorted_dates[year][month].keys.each do |weekday|
          dates = sorted_dates[year][month][weekday]
          if (dates.size == 2) && (sorted_month[weekday][0] == dates[0]) && (sorted_month[weekday][2] == dates[1])
            matches << "First and Third #{Date::DAYNAMES[weekday]} in #{Date::MONTHNAMES[month]} #{year}"
          end
        end
      end
    end
    matches
  end

  def match_second_and_fourth(sorted_dates)
    matches = []
    sorted_dates.keys.each do |year|
      sorted_dates[year].keys.each do |month|
        sorted_month = sort_dates(all_dates_in_month(month, year))[year][month]
        sorted_dates[year][month].keys.each do |weekday|
          dates = sorted_dates[year][month][weekday]
          if (dates.size == 2) && (sorted_month[weekday][1] == dates[0]) && (sorted_month[weekday][3] == dates[1])
            matches << "Second and Fourth #{Date::DAYNAMES[weekday]} in #{Date::MONTHNAMES[month]} #{year}"
          end
        end
      end
    end
    matches
  end

  # Returns the count for a given day of the week in a given month,
  # i.e. there are 5 Tuesdays in November 2011
  def days_of_week_count_for_month(month, year, day_of_week)
    whole_month = all_dates_in_month(month, year)
    
    sort_dates(whole_month)[year][month][day_of_week].size
  end

  # returns an Array of Date objects for all days in the month
  def all_dates_in_month(month, year)
    first_day = Date.civil(year, month, 1)
    last_day = Date.civil(year, month, -1)
    
    (first_day..last_day).to_a
  end
end
