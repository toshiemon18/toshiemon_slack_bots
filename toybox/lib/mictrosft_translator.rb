# coding : utf-8

require "rubygems"
require "net/http"
require "json"

# ToshiemonSlackBots
#   This module is the namespace for toshiemon slack-bots definition
module ToshiemonSlackBots
  # MicrosoftTranslator
  #   This module is the namespace for microsoft api
  module MicrosoftTranslator
    # Client
    #   This class is a microsoft api Client
    class Client
    end


    # AzureAuthentication
    #   This class is a microsoft azure authenticator
   class AzureAuthentication
      AUTH_URL = URI.parse("https://api.microsofttranslator.com/V2/Http.svc/Translate").freeze

      def initialize(key1, key2)
        @key1 = key1
        @key2 = key2
        @token = get_token
      end

      private
      # get_token
      #  @param [String] api_key tokenを取得するためのキー
      #  @return [String] 取得したtoken
      def get_token
        http = Net::HTTP.new(AUTH_URL.host, AUTH_URL.port)
        header = {"Ocm-Apim-Subscription-Key": @key2}
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        response = http.post(AUTH_URL.path, "", header)
        token = response.token
      end
    end
  end
end
