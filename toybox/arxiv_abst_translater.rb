# coding : utf-8

$:.unshift(File.join(File.dirname(__FILE__), "lib"))

require 'rubygems'
require 'nokogiri'
require "open-uri"
require "net/https"
require "microsoft_translator"

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

      def run
        abstract = fetch_abstract
        @client.translate(abstract, to: "ja")
      end

      private
      def fetch_html
        html = Nokogiri::HTML.parse(open(@url))
      end

      def fetch_abstract
        html = fetch_html
        abstract = html.xpath("//*[@id=\"abs\"]/div[2]/blockquote/text()").text
        # Eliminate new-line code and whitespace, hyphenations
        abstract.gsub!("\n", " ").strip!.gsub!("- ", "")
      end
    end
  end
end
