require_relative "./meta_content"
require_relative "./photo"
module Elegant
  module Response
    class Content
      attr_reader :id, :meta
      def initialize(res)
        fail "TODO: add :content-type and :fields methods"
        @id = res["id"]
        @meta = MetaContent.new(res["meta"])
        fields = res["attributes"]["fields"]
        fields.each do |(name, val)|
          define_singleton_method name.gsub(/[- ]/, '_'), -> () do
            if val.respond_to?(:keys) && val.keys.include?("url") && val.keys.include?("file-size")
              Photo.new(val)
            else
              val
            end
          end
        end
      end

      def fetched_at
        self.meta.fetched_at
      end

      def updated_at
        self.meta.updated_at
      end

      def created_at
        self.meta.created_at
      end

      def <=>(other)
        return super unless other.is_a?(Content)
        if self.respond_to?(:order) && other.respond_to?(:order)
          self.order <=> other.order
        else
          self.updated_at <=> other.updated_at
        end
      end
    end
  end
end


