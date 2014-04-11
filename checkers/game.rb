require 'debugger'

require './piece'
require './board'

class Game

	attr_accessor :board

	def initialize
		@board = Board.new(true)
	end

	def play
		puts "\e[H\e[2J"
		puts "WELCOME TO CHECKERS!"
		puts
		loop do

			self.board.print_board
			puts "Please enter a move, or selection of moves."
			puts "Format: '5,5 | 4,1'  OR  '2,3 | 4,5 | 6,3' "
			user_input = gets.chomp
			user_input = user_input.split('|')
			array_of_moves = []
			user_input.each do |position|
				array_of_moves << [position.lstrip.rstrip[0].to_i, position.lstrip.rstrip[-1].to_i]
			end

		p array_of_moves
		self.board[array_of_moves.first].perform_moves(array_of_moves.drop(1))
		puts
		end
	
	end

end

game = Game.new

p game.board.print_board

game.play