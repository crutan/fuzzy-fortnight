require "test_helper"

class CarTest < ActiveSupport::TestCase
  test "a car can have many trims" do
    assert_equal cars(:civic).trims.size, 2
  end
end
