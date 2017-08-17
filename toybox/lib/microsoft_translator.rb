# coding : utf-8

require "rubygems"
require "net/http"
require "net/https"
require "json"
require "uri"
require "faraday"
require "nokogiri"

# ToshiemonSlackBots
#   This module is the namespace for toshiemon slack-bots definition
module ToshiemonSlackBots
  # MicrosoftTranslator
  #   This module is the namespace for microsoft api
  module MicrosoftTranslator
    ENDPOINT = "https://api.microsofttranslator.com"
    # Client
    #   This class is a microsoft api Client
    class Client
      def initialize
        key1 = ENV["MS_TRANSLATE_API_KEY1"]
        key2 = ENV["MS_TRANSLATE_API_KEY2"]
        tokens = AzureAuthentication.new.get_token(key2)
        @token = tokens[:token]
        @expired_at = tokens[:expired_at]
      end

      def translate(text, **params)
        raise "Must provide params[:to]" if params[:to].nil?
        raise "Must provide text"        if text.nil?
        post_params = {
          "text":        text.to_s,
          "from":        params[:from],
          "to":          params[:to],
          "category":    'generalnn',    # ニューラルネットによる翻訳機能を使う
          "contentType": params[:content_type] || 'text/plain'
        }
        client(@token, post_params)
      end

      private
      def client(token, params)
        connector = Faraday::Connection.new(url: ENDPOINT) do |faraday|
          faraday.use Faraday::Request::UrlEncoded
          # faraday.use Faraday::Response::Logger
          faraday.use Faraday::Adapter::NetHttp
        end
        headers = params
        headers[:appid] = "Bearer #{token}"
        response = connector.get("/v2/http.svc/Translate", headers)
        Nokogiri::XML.parse(response.body).text
      end
    end


    # AzureAuthentication
    #   This class is a microsoft azure authenticator
    class AzureAuthentication
      AUTH_URL = URI.parse("https://api.cognitive.microsoft.com/sts/v1.0/issueToken").freeze

      # get_token
      #  @param [String] api_key tokenを取得するためのキー
      #  @return [Hash] 取得したtokenと失効時間を含むハッシュ
      def get_token(api_key)
        http = Net::HTTP.new(AUTH_URL.host, AUTH_URL.port)
        header = {"Ocp-Apim-Subscription-Key": api_key}
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        response = http.post(AUTH_URL.path, "", header)
        token = response.body
        expired_time = expired_at
        puts "[#{Time.now}] - Get access token for Microsoft TranslatorAPI"
        puts "                 warning : This token expired at #{expired_time}"
        {token: token, expired_at: expired_time}
      end

      private
      # expired_at
      #   @return [Time] トークンの失効時間
      def expired_at
        Time.now + 600
      end
    end
  end
end
