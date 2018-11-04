require "test_helper"

class Elegant::VersionTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Elegant::VERSION
  end
end
