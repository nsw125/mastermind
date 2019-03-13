module CodeCreator

    def create_color(number)
        code_string = ''
        number.times do 
            color = rand(1..6)
            case color
            when 1
                color =  'red'
            when 2
                color = 'orange'
            when 3
                color = 'yellow'
            when 4
                color = 'green'
            when 5
                color = 'blue'
            when 6
                color = 'purple'
            end
            code_string += " " + color
        end
        code_string
    end
end

class Game

    def initialize
        puts "Welcome to Mastermind!"
        puts "Which would you like to play as?"
        puts
        puts "1. Codebreaker"
        puts 'or'
        puts "2. Codemaker"
        puts
        game_choice = gets.chomp
        until game_choice == '1' or game_choice == '2'
            puts "Not an option, choose 1 or 2."
            game_choice = gets.chomp
        end
        case game_choice
        when '1'
            play = CodeBreaker.new
            play.round
        when '2'
            play = CodeMaker.new
            play.round
        end
    end

end

class CodeBreaker

    def initialize
        puts "First, what is your name?"
        @player1 = Player.new(gets.chomp)
        puts "Okay, #{@player1.name}, how many guesses would you like?"
        puts "You can choose 6, 8, 10, 12. (6/8/10/12)"
        @guesses = gets.chomp.to_i
        until @guesses == 6 or @guesses == 8 or @guesses == 10 or @guesses == 12
            puts "That is not an option, please select (6/8/10/12)."
            @guesses = gets.chomp.to_i
        end
        @secret_code = []
    end
    include CodeCreator

    def round
        @secret_code = create_color(4).split(' ')
        @turn_counter = 1
        @guesses.times do
            puts
            puts
            puts "Turn: #{@turn_counter}"
            puts "Enter four colors, each seperated with a space (ex. green blue green red)."
            @guess = gets.chomp.split(' ')
            until @guess[3].is_a? String and @guess[4] == nil
                puts "You must enter exactly four colors, seperated by a space, to proceed."
                @guess = gets.chomp.split(' ')
            end
            compare_codes
            @turn_counter += 1
        end
        puts "Oh no, you didn't guess the correct code in time!"
        puts "The Secret Code was: #{@secret_code.join(" : ")}"
        puts "Try again!"
    end
    
    def compare_codes

        correct_position = []
        @guess.each_with_index do |color, index|
            if @guess[index] == @secret_code[index]
                correct_position.push(color)
            end
        end
        correct_color = @guess.select { |i| @secret_code.any? { |color| color == i}}
        if correct_position.length == 4
            puts "CONGRATULATIONS! You WIN!"
            puts "The Secret Code was: #{@secret_code.join(" : ")}"
            if @turn_counter == 1
                puts "HOLY COW! You solved this on the first turn!!"
            else
                puts "You solved this code in #{@turn_counter} turns!"
            end
            exit
        else
            puts "Correct colors: #{correct_color.uniq.length}      Correct Position: #{correct_position.length}"
        end

    end
end

class CodeMaker

    def initialize
        puts "First, what is your name?"
        @player1 = Player.new(gets.chomp)
        puts "How many guesses would you like the computer to have? (6/8/10/12)"
        @guesses = gets.chomp.to_i
        until @guesses == 6 or @guesses == 8 or @guesses == 10 or @guesses == 12
            puts "That is not an option, please select (6/8/10/12)."
            @guesses = gets.chomp.to_i
        end
        puts "Alrighty, #{@player1.name}, enter in a four color code, each seperated by a space!"
        puts "You can repeat colors (ex. red red blue yellow)"
        puts "Your colors you can use are: red, orange, yellow, green, blue, purple."
        @secret_code = gets.chomp.split(' ')
        puts "Your secret code is: #{@secret_code.join(" : ")}"
    end

    include CodeCreator

    def round
        computer_guess
    end

    def computer_guess
        @guess = create_color(4).split(' ')
        guess_counter = 1
        correct_colors = []
        @guesses.times do
            puts
            puts "Turn: #{guess_counter}"
            puts "The Computer's guess: #{@guess}"
            if @guess == @secret_code
                puts "The computer has guessed your code! Try again!"
                exit
            else
                puts "Didn't get it this time!"
                puts "Time for another guess!"
                new_guess = []
                @guess.each_with_index do |color, index|
                    if @guess[index] == @secret_code[index]
                        new_guess.push(color)
                        correct_colors.push(color)
                    else
                        new_color = create_color(1).strip
                        new_guess.push(new_color)                       
                    end
                end
            end
            @guess = new_guess
            correct_colors = correct_colors.uniq
            puts correct_colors.join(', ')
            guess_counter += 1
        end
        puts "You win! The computer couldn't guess your awesome code!"   
    end
end

class Player

    attr_accessor :name
    def initialize(name)
        @name = name
    end


end

game = Game.new