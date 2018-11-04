require "test_helper"

class Elegant::ClientTest < Minitest::Test
  def subject
    @subject ||= Elegant::Client.new("url", {})
  end

  def test_find_adds_uuid
    assert_equal "filter[uuid]=9090", subject.find('9090')
  end

  def test_find_throws_error_for_non_strings
    assert_raises ArgumentError do
      subject.find({ lol: "I'm not a valid id"})
    end

    assert_raises { subject.find(909090) }
    assert_raises { subject.find([]) }
  end

  def test_content_type_looks_up_content_type
    expected = "filter[type]=players&filter[status]=live&filter[publish_status]=published&page[number]=1&page[size]=25&sort=created_at"
    assert_equal expected, subject.content_type("players")
  end

  def test_content_type_custom_sort_by
    assert_includes subject.content_type("players", sort_by: 'order'), "sort=order"
  end

  def test_content_type_publish_status
    assert_includes subject.content_type("p", publish_status: :expired), "filter[publish_status]=expired"
  end

  def test_content_type_status
    assert_includes subject.content_type("p", status: 'archived'), "filter[status]=archived"
  end

  def test_content_type_page
    assert_includes subject.content_type("p", page: 2), "page[number]=2"
  end

  def test_content_type_size
    assert_includes subject.content_type("p", size: 50), "page[size]=50"
  end

  def test_published
    assert_equal "filter[publish_status]=published", subject.published
  end

  def test_expired
    assert_equal "filter[publish_status]=expired", subject.expired
  end

  def test_live
    assert_equal "filter[status]=live", subject.live
  end

  def test_draft
    assert_equal "filter[status]=draft", subject.draft
  end

  def test_all
    assert_equal "", subject.all
  end
end
