require "test/unit"
require File.dirname(__FILE__) + './lib/readable_recurrences'

class ReadableRecurrencesTest < Test::Unit::TestCase

  def setup
    @rr = ReadableRecurrences
  end
  
  def test_converts_strings_into_date_objects
    string_dates = ['2010-11-01', '2010-11-08', '2010-11-15',
                    '2010-11-22', '2010-11-29']
    parsed_dates = @rr.parse_dates(string_dates)
    
    assert_equal parsed_dates.size, string_dates.size
    parsed_dates.each {|pd| assert_instance_of Date, pd}
  end

  def test_sorts_dates_into_a_hash
    string_dates = ['2010-11-01', '2010-11-08', '2010-11-15',
                    '2010-11-22', '2010-11-29']
    expected_hash = {2010 => {11 =>{1 =>[1,8,15,22,29]}}}

    assert_equal expected_hash, @rr.sort_dates(string_dates)
  end
  
  def test_sorts_dates_spanning_multiple_years_into_a_hash
    string_dates = ['2010-11-01', '2010-12-06', '2011-01-03']
    expected_hash = {
      2010 => {
        11 =>{1 => [1]},
        12 => {1 => [6]}},
      2011 => {
        1 => { 1 => [3]}}}
    
    assert_equal expected_hash, @rr.sort_dates(string_dates)
  end

  def test_calculates_number_of_day_in_month
    assert_equal 5, @rr.days_of_week_count_for_month(11,2010,1)
    assert_equal 4, @rr.days_of_week_count_for_month(11,2010,0)
  end

  def test_parses_weekly_events_that_are_on_the_same_week_day
    string_dates = ['2010-11-01', '2010-11-08', '2010-11-15',
                    '2010-11-22', '2010-11-29']
    assert_equal "Every Monday in November 2010", @rr.find(string_dates)
  end

  def test_parses_weekly_events_that_are_on_the_same_week_day_over_multiple_months
    string_dates = ['2010-11-01', '2010-11-08', '2010-11-15', '2010-11-22',
                    '2010-11-29', '2010-12-06', '2010-12-13', '2010-12-20',
                    '2010-12-27']
    expected_string = "Every Monday in November 2010 and Every Monday in December 2010"
    assert_equal expected_string, @rr.find(string_dates)
    
  end
end
