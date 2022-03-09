class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end
  
  def guess x
    if x.nil? or x.empty? or x =~ /[^a-z]/i
      raise ArgumentError.new
    end

    x.downcase!
    if (@guesses.include? x or @wrong_guesses.include? x)
      return false
    end
      
    if @word.include? x
      @guesses += x
    else
      @wrong_guesses += x
    end
  end
  
  def word_with_guesses
    @guesses.empty? ? (@word.gsub(/./, '-')) : (@word.gsub(/[^#{@guesses}]/, '-'))
  end
  
  def check_win_or_lose
    if @wrong_guesses.length >= 7
      :lose
    elsif word_with_guesses.downcase == @word.downcase
      :win
    else
      :play
    end
  end
end
