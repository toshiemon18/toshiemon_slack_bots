# coding : utf-8

require 'rubygems'
require 'nokogiri'
require "./lib/microsoft_translator"

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
        @client = MicrosoftTranslator::Client.new
      end
    end
  end
end
