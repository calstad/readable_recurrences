require "date"

module ReadableRecurrences
  extend self
  
  def find(dates)
    parsed_dates = parse_dates(dates)
    sorted_dates = sort_dates(parsed_dates)
    match_recurrences(sorted_dates)
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

  #matches every week occurrences 
  def match_recurrences(sorted_dates)
    matches = []
    sorted_dates.keys.each do |year|
      sorted_dates[year].keys.each do |month|
        sorted_month = sort_dates(all_dates_in_month(month, year))[year][month]
        sorted_dates[year][month].keys.each do |weekday|
          dates = sorted_dates[year][month][weekday]
          if dates == sorted_month[weekday]
            matches << "Every #{Date::DAYNAMES[weekday]} in #{Date::MONTHNAMES[month]} #{year}"
          elsif dates.size == 2
            if (sorted_month[weekday][0] == dates[0]) && (sorted_month[weekday][2] == dates[1])
              matches << "First and Third #{Date::DAYNAMES[weekday]} in #{Date::MONTHNAMES[month]} #{year}"
            elsif (sorted_month[weekday][1] == dates[0]) && (sorted_month[weekday][3] == dates[1])
              matches << "Second and Fourth #{Date::DAYNAMES[weekday]} in #{Date::MONTHNAMES[month]} #{year}"
            end
          end
        end
      end
    end
    matches.join(' and ')
  end

  # returns an Array of Date objects for all days in the month
  def all_dates_in_month(month, year)
    first_day = Date.civil(year, month, 1)
    last_day = Date.civil(year, month, -1)
    
    (first_day..last_day).to_a
  end
end
