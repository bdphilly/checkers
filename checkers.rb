class Board

	# attr_accessor :rows

	def initialize(fill_board = true)
		make_starting_grid(fill_board)
	end

	def [](pos)
    # raise "invalid pos" unless valid_pos?(pos)
		
		i,j = pos
		@rows[i][j]
	end

	def []=(pos,piece)
		# raise "invalid pos" unless valid_pos?(pos)

		i,j = pos
		@rows[i][j] = piece
	end

	def add_piece(piece, pos)
		# raise "position not empty" unless self.empty?(pos)
		self[pos] = piece
	end

	# def empty?(pos)
	# 	self[pos].nil?
	# end

	# def valid_pos?(pos)
 #    pos.all? { |coord| coord.between?(0, 7) }
 #  end

	# protected

	def make_starting_grid(fill_board)
		@rows = Array.new(8) { Array.new(8) }
		
		if fill_board
	 		3.times do |row|
	 			8.times do |col|
	 				Piece.new(:white, self, [row, col]) unless (col+row).even?
	 				Piece.new(:black, self, [5+row, col]) unless (col+row).odd?
	 			end
	 		end
		end
	end

	def render_board
		@rows.map do |row|
			row.map do |piece|
				# p piece.render
				piece.nil? ? " . " : piece.render[piece.color]
			end.join
		end.join("\n")
	end

end

class Piece

	attr_accessor :board, :color, :pos

	def initialize(color, board, pos)
		@color, @board, @pos = color, board, pos

		board.add_piece(self, pos)

	end

	def render
		{ :white => " W ", :black => " B " }
	end

end

board = Board.new(true)
puts board.render_board
