# frozen_string_literal: true

require_relative "./version"
require 'http'
require 'json'


module Elegant
  class API
    URL = "https://api.elegantcms.io/api/v1/contents"

    def initialize(api_key:, cache_time: 15, version: 'v1', url: URL)
      @api_key = api_key
      @url     = url
      @version = version
      @headers = {
        "Accept"        => "application/json",
        "Authorization" => "Bearer '#@api_key'",
        "User-agent"    => "elegant/#{Elegant::VERSION};ruby"
      }
      @client = Client.new(@url, @headers)
    end
  end

  class Client

    def initialize(url, headers)
      @url     = url
      @headers = headers
    end

    def find(id)
      fail ArgumentError, "ID must be a UUID String" unless id.is_a?(String)
      where(id: id)
    end

    def content_type(type,
                     sort_by:        :created_at,
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
    attr_reader :url

    def publish_status(p_status)
      where(publish: p_status)
    end

    def draft_status(d_status)
      where(status: d_status)
    end

    def where(**qs)
      [].tap do |params|
        add_param(params, "filter[uuid]",           :id,      qs)
        add_param(params, "filter[type]",           :type,    qs)
        add_param(params, "filter[status]",         :status,  qs)
        add_param(params, "filter[publish_status]", :publish, qs)
        add_param(params, "page[number]",           :page,    qs)
        add_param(params, "page[size]",             :size,    qs)
        add_param(params, "sort",                   :sort_by, qs)
      end.join("&")
    end

    def get(request)
      JSON.parse(Http.headers(headers).get(url + '/?' + request))["data"]
    end

    def add_param(bucket, query, name, supplied_params)
      bucket << "#{query}=#{supplied_params.fetch(name)}" if supplied_params[name]
    end
    #Equivalent to passing no parameters
    # https://apps.elegantcms.io/api/v1/contents?
    # filter[publish_status]=published&
    # filter[status]=live&
    # page[number]=1&
    # page[size]=25&
    # sort=-updated_at
  end
end
