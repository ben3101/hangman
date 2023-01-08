
# class for running each game
class Game
  def initialize
    @hm = Hangman.new
    @game_over = false
    start_game
  end

  def start_game
    puts "This is Hangman. Your #{@hm.word.length}-letter word has been selected. You are allowed up to 7 mistakes. Good luck!"
    puts @hm.display
    puts "\n"
    guess_letter until @game_over
    play_again
  end

  def guess_letter
    guess = ''
    while guess.length != 1
      puts 'Guess a letter.'
      guess = gets.downcase.chomp
    end
    update_display(guess)
  end

  # takes guesses and updates the display to include letters that were correctly guessed. Incorrect guesses are added to the list.
  def update_display(guess)
    if @hm.word.include?(guess)
      locations = (0..@hm.word.length).find_all { |c| @hm.word[c, 1] == guess }
      locations.each do |index|
        @hm.display[index] = guess
      end
    else
      puts 'Incorrect!'
      unless @hm.incorrect_guesses.include?(guess)
        @hm.incorrect_guesses.push(guess)
      end
    end
    puts "#{@hm.display}   \t\t Remaining Guesses: #{7-@hm.incorrect_guesses.length} #{@hm.incorrect_guesses}"
    puts "\n"
    return if @hm.display.include?('_') && @hm.incorrect_guesses.length < 7

    @game_over = true
  end

  def play_again
    if @hm.game_result == 'win'
      puts 'You got it, well done!'
    elsif @hm.game_result == 'lose'
      puts 'You\'re out of guesses. Better luck next time!'
      puts "The word was #{@hm.word}"
    end
    puts "\nEnter 'y' to play again or anything else to exit."
    ans = gets.chomp
    return unless ans == 'y'

    Game.new
  end
end

# class for hangman methods and data
class Hangman

  attr_accessor :display, :incorrect_guesses
  attr_reader :word

  def initialize
    @word = pick_word
    @display = generate_display
    @incorrect_guesses = []
  end

  # selects a random word
  def pick_word
    dictionary_file = File.open('google-10000-english-no-swears.txt', 'r')
    words = dictionary_file.readlines
    # suitable words are between 5 and 12 characters. Including the newline character it is 6 to 13
    suitable = words.select { |word| word.length >= 6 && word.length <= 13 }
    suitable.sample.chomp
    # chosen_words.each{|word| word = word.chomp
  end

  # generates the initial display for the word. '_'s for each letter
  def generate_display
    display = ''
    i = 0
    until i >= word.length
      display += '_'
      i += 1
      # display+=' '
    end
    display
  end

  def game_result
    if display.include?('_') == false
      'win'
    else
      'lose'
    end
  end
end

Game.new