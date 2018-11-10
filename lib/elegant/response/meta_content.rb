module Elegant
  module Response
    class MetaContent
      attr_reader :fetched_at, :updated_at, :created_at, :updated_by, :created_by
      def initialize(raw)
        @updated_at = Time.parse raw["updated_at"]
        @updated_by = raw["updated_by"]
        @created_at = Time.parse raw["created_at"]
        @created_by = raw["created_by"]
        @fetched_at = Time.now.utc
      end
    end
  end
end

