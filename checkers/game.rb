require 'debugger'

require './piece'
require './board'

class Game

	attr_accessor :board

	def initialize
		@board = Board.new(true)
	end

	def play

	end

end

class Player
	
	def game_interaction

		puts "WELCOME TO CHECKERS!"
		puts
		puts "Please enter a move, or selection of moves."
		puts "Format: '5,5 | 4,1'  OR  '2,3 | 4,5 | 6,3' "
		user_input = gets.chomp
		user_input = user_input.split('|')
		array_of_moves = []
		user_input.each do |position|
			array_of_moves << [position.lstrip.rstrip[0].to_i, position.lstrip.rstrip[-1].to_i]
		end

		p array_of_moves

	end
end

player = Player.new
player.game_interaction

game = Game.new
puts

game.board.print_board

# p game.board[[2,3]].color
p game.board[[3,4]].nil?

# remove_piece(piece, pos)

game.board


game.board[[2,5]] = nil
game.board[[0,7]] = nil

game.board[[5,2]] = nil
game.board[[5,2]] = Piece.new(:red, game.board, [5,2])
game.board[[3,4]] = Piece.new(:red, game.board, [3,4])
# game.board.add_piece(Piece.new(:black, self))


game.board.print_board

puts

p game.board[[6,1]].perform_moves([[4,3],[2,5],[0,7]])

# p game.board[[4,3]].perform_moves([[6,5]])#,[6,3]])#,[4,1]])

game.board.print_board