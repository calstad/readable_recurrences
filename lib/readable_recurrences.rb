require "date"
directory = File.expand_path(File.dirname(__FILE__)) + '/readable_recurrences'
Dir.glob(directory + '/*.rb').each do |required_file|
  require required_file
end

module ReadableRecurrences
  extend self
  DEFAULT_PATTERNS = [Pattern.new(:weeks => [1,2,3,4,5], :description => 'Every'),
                      Pattern.new(:weeks => [1,3], :description => 'First and Third'),
                      Pattern.new(:weeks => [2,4], :description => 'Second and Fourth'),
                     ]
  
  def find(dates, default=true)
    m = Matcher.new
    m.patterns += DEFAULT_PATTERNS
    m.find(dates)
  end
end
