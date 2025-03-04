# frozen_string_literal: true

require 'net/http'
require 'json'
require 'open-uri'

# Games controller handles word game logic
class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].split
    @message = compute_score(@word, @letters)
  end

  private

  def compute_score(word, letters)
    return '❌ Not in the grid!' unless word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
    return '❌ Not a valid English word!' unless valid_word?(word)

    "✅ Congratulations! '#{word}' is a valid word!"
  end

  def valid_word?(word)
    url = "https://dictionary.lewagon.com/#{word}"

    begin
      response = URI.open(url).read
      JSON.parse(response)["found"] # Returns true if the word exists
    rescue OpenURI::HTTPError
      false # If API request fails, assume the word is invalid
    end
  end
end
