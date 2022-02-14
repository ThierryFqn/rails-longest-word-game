require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(10)
  end

  def score
    @word = params[:word]
    @english_valid_word = english_word?(@word)
    @grid_letters = params[:letters].split(" ")
    @grid_valid_word = word_in_grid?(@word, @grid_letters)
    @result = result
  end

  def result
    if @english_valid_word && @grid_valid_word
      @score = scoring(@word)
      "Congratulations #{@word} is a valid word"
    elsif !@english_valid_word && @grid_valid_word
      "Sorry but  #{@word}  does not seem to be an English Word"
    elsif @english_valid_word && !@grid_valid_word
      "Sorry but #{@word} can't be built out of #{@grid_letters}"
    else
      "#{@word} is not in the grid and not an english word"
    end
  end

  private

  def scoring(attempt)
    attempt.length * 10
  end

  def english_word?(input_word)
    url = "https://wagon-dictionary.herokuapp.com/#{input_word}"
    word_serialized = URI.open(url).read
    word_check = JSON.parse(word_serialized)
    word_check['found']
  end

  def word_in_grid?(input_word, grid)
    input_word.upcase.chars.all? { |letter| input_word.upcase.count(letter) <= grid.count(letter) }
  end

  def generate_grid(grid_size)
    grid = []
    grid_size.times { grid << ('A'..'Z').to_a.sample }
    grid
  end
end
