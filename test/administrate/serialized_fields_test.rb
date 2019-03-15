require "test_helper"

class Administrate::SerializedFieldsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Administrate::SerializedFields::VERSION
  end
end
