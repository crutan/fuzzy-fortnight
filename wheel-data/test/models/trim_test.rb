require "test_helper"

class TrimTest < ActiveSupport::TestCase

  test "only one tire fits the yugo" do
    assert_equal trims(:yugo_22).wheels_that_fit.size, 1
  end

  test "many rims fit the civic si" do
    assert trims(:civic_si).wheels_that_fit.size > 1
  end

  test "the 22s do not fit the civic si" do
    assert_not trims(:civic_si).wheels_that_fit.include?(wheels("22s"))
  end

end
