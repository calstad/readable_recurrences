require "test/unit"
require File.dirname(__FILE__) + './lib/readable_recurrences'

class ReadableRecurrencesTest < Test::Unit::TestCase

  def setup
    @rr = ReadableRecurrences
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

  def test_parses_first_and_third_same_week_day_events
    string_dates = ['2010-11-03', '2010-11-17']
    expected_string = "First and Third Wednesday in November 2010"

    assert_equal expected_string, @rr.find(string_dates)
  end

  def test_parses_first_and_third_same_week_day_events_over_multiple_months
    string_dates = ['2010-11-03', '2010-11-17', '2010-12-01', '2010-12-15']
    expected_string = "First and Third Wednesday in November 2010 and First and Third Wednesday in December 2010"

    assert_equal expected_string, @rr.find(string_dates)
  end

  def test_parses_second_and_fourth_same_week_day_events
    string_dates = ['2010-11-10', '2010-11-24']
    expected_string = "Second and Fourth Wednesday in November 2010"

    assert_equal expected_string, @rr.find(string_dates)
  end

  def test_parses_second_and_fourth_same_week_day_events_over_multiple_months
    string_dates = ['2010-11-10', '2010-11-24', '2010-12-08', '2010-12-22']
    expected_string = "Second and Fourth Wednesday in November 2010 and Second and Fourth Wednesday in December 2010"

    assert_equal expected_string, @rr.find(string_dates)
  end

end
