require "date"
directory = File.expand_path(File.dirname(__FILE__)) + '/readable_recurrences'
Dir.glob(directory + '/*.rb').each do |required_file|
  require required_file
end

module ReadableRecurrences
  extend self
  #Currently this library allows you determine the recurrence patterns
  #weekly or monthly events. To definie your own pattern, the find
  #method takes an optional extra_patterns array.
  #Example:
  # ReadableRecurrences.find(['2010-11-01', '2010-11-08', '2010-11-15'],
  #                          {:default => false,
  #                            :extra_patterns => [Pattern.new(:weeks => [1,2,3], :description => 'First Three']}
  #
  # Would return 'First Three Mondays in November 2010'

  DEFAULT_PATTERNS = [Pattern.new(:weeks => [1,2,3,4,5], :description => 'Every'),
                      Pattern.new(:weeks => [1,3], :description => 'First and Third'),
                      Pattern.new(:weeks => [2,4], :description => 'Second and Fourth'),
                     ]

  
  def find(dates, options={})
    {:default => true}.merge!(options)
    
    m = Matcher.new
    m.patterns += DEFAULT_PATTERNS if options[:default]
    m.patterns += options[:extra_patterns] if options[:extra_patterns]
    
    m.find(dates)
  end
end
