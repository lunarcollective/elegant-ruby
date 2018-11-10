module Elegant
  module Request
    class Query
      def find(id)
        fail ArgumentError, "ID must be a UUID String" unless id.is_a?(String)
        where(id: id)
      end

      def content_type(type,
                       sort_by:        :updated_at,
                       publish_status: :published,
                       status:         :live,
                       page:           1,
                       size:           25)
        fail ArgumentError, "Type must be a String" unless type.is_a?(String)
        fail ArgumentError, "PublishStatus must be one of (:published, :expired)" unless [:published, :expired].include?(publish_status)
        where(
          type: type,
          sort_by: sort_by,
          publish: publish_status,
          status: status,
          page: page,
          size: size)
      end

      def published
        publish_status(:published)
      end

      def expired
        publish_status(:expired)
      end

      def live
        draft_status(:live)
      end

      def draft
        draft_status(:draft)
      end

      def all
        where
      end

      private
      attr_reader :url, :headers

      def publish_status(p_status)
        where(publish: p_status)
      end

      def draft_status(d_status)
        where(status: d_status)
      end

      def where(**qs)
        @request = [].tap do |params|
          add_param(params, "filter[uuid]",           :id,      qs)
          add_param(params, "filter[type]",           :type,    qs)
          add_param(params, "filter[status]",         :status,  qs)
          add_param(params, "filter[publish_status]", :publish, qs)
          add_param(params, "page[number]",           :page,    qs)
          add_param(params, "page[size]",             :size,    qs)
          add_param(params, "sort",                   :sort_by, qs)
        end.join("&")
      end

      def add_param(bucket, query, name, supplied_params)
        bucket << "#{query}=#{supplied_params.fetch(name)}" if supplied_params[name]
      end
    end
  end
end
