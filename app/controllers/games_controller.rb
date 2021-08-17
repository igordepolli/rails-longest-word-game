require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    alphabet_array = ('A'..'Z').to_a
    vowels = %w[A E I O U]
    number_of_letters = rand(8..10)

    (number_of_letters * 0.3).round.times do
      @letters << vowels.sample
    end

    @letters << alphabet_array.sample while @letters.size < number_of_letters
  end

  def score
    attemp = params['word-input']
    if attempt_match_grid?(attemp)
      url = "https://wagon-dictionary.herokuapp.com/#{attemp}"
      response_json = JSON.parse(open(url).read)

      @message = if response_json['found']
                   "Congrulations! #{attemp} is a valid English word"
                 else
                   "Sorry but #{attemp} does not seem to be a valid English word..."
                 end
    else
      @message = "Sorry but #{attemp} can't be built out of #{@letters.join(', ')}"
    end
  end

  private

  def attempt_match_grid?(attemp)
    array_attemp = attemp.upcase.chars
    @letters = params[:letters].split
    array_attemp.each do |letter|
      return false if @letters.size.zero? || !@letters.include?(letter)

      @letters.delete_at(@letters.index(letter))
    end
    true
  end
end
