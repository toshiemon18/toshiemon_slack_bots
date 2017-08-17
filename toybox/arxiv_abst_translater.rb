# coding : utf-8

require 'rubygems'
require 'nokogiri'

# ToshiemonSlackBots
#   This module is the namespace for toshiemon slack-bots definition
module ToshiemonSlackBots
  # Toybox
  #   This module is the namespace for description of bot tasks
  module Toybox
    # ArXivAbstTranslator
    #   This class is a translator with paper abstract on arXiv.org
    class ArXivAbstTranslator
      attr_writer :url

      def initialize(url)
        @url = url
        @consumer_key = ENV["MS_TRANSLATE_CS_KEY"]
        @consumer_secret = ENV["MS_TRANSLATE_CS_SECRET"]
        @token = ENV["MS_TRANSLATE_TOKEN"]
      end
    end
  end
end
