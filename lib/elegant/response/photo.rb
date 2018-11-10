module Elegant
  module Response
    class Photo
      attr_reader :title, :content_type, :file_size, :url
      def initialize(raw)
        @url = raw["url"]
        @title = raw["title"]
        @file_size = raw["file-size"]
        @content_type = raw["content-type"]
      end
    end
  end
end
