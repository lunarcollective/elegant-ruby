# frozen_string_literal: true

require_relative "./version"
require_relative "./request/query"
require_relative "./response/content"
require 'http'
require 'json'


module Elegant
  class API
    URL = "https://api.elegantcms.io/api/v1/contents"
    attr_reader :client

    def initialize(api_key:, cache_time: 15, version: 'v1', url: URL)
      @api_key = api_key
      @url     = url
      @version = version
      @headers = {
        "Accept"        => "application/json",
        "Authorization" => "Token token=#@api_key",
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
      send Request::Query.new.find(id)
    end

    def content_type(type,
                     sort_by:        :updated_at,
                     publish_status: :published,
                     status:         :live,
                     page:           1,
                     size:           25)
      request = Request::Query.new.content_type(
        type,
        sort_by: sort_by,
        publish_status: publish_status,
        status: status,
        page: page,
        size: size)

      send request
    end

    def published
      send Request::Query.new.published(:published)
    end

    def expired
      send Request::Query.new.expired(:expired)
    end

    def live
      send Request::Query.new.live(:live)
    end

    def draft
      send Request::Query.new.draft(:draft)
    end

    def all
      send Request::Query.new.all
    end

    def send(request = @request)
      res = get(request)
      res.map { |x| Response::Content.new(x) }
    end

    private
    attr_reader :url, :headers

    def get(request)
      res = Http.headers(headers).get(url + '/?' + request)
      JSON.parse(res)["data"]
    end

  end
end
