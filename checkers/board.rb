class Board

	attr_accessor :rows

	def initialize(fill_board = true)
		make_starting_grid(fill_board)
	end

	def [](pos)
    raise "invalid pos" unless valid_pos?(pos)
		
		i,j = pos
		@rows[i][j]
	end

	def []=(pos,piece)
		raise "invalid pos" unless valid_pos?(pos)

		i,j = pos
		@rows[i][j] = piece
	end

	def add_piece(piece, pos)
		raise "position not empty" unless self.empty?(pos)

		self[pos] = piece
	end

	def remove_piece(piece, pos)
		self[pos] = nil
	end

	def empty?(pos)
		self[pos].nil?
	end

	def valid_pos?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
	end

	def make_starting_grid(fill_board)
		@rows = Array.new(8) { Array.new(8) }
		
		if fill_board
	 		3.times do |row|
	 			8.times do |col|
	 				Piece.new(:red, self, [row, col], :soldier) unless (col+row).even?
	 				Piece.new(:black, self, [5+row, col], :soldier) unless (col+row).odd?
	 			end
	 		end
		end
	end

	def dup_board
		new_board = Board.new(false)

		pieces.each do |piece|
			Piece.new(piece.color, new_board, piece.pos, piece.rank)
		end

		new_board
	end

	def pieces
		@rows.flatten.compact
	end

	def render_board
		puts '   0  1  2  3  4  5  6  7'
		puts'  -----------------------'
		@rows.map do |row|
			row.map do |piece|
				piece.nil? ? " . " : piece.render[piece.color]
			end.join
		end.join("\n")
	end

	def print_board
		i = 0
		render_board.split("\n").each do |row|
			puts "#{i}|#{row}"
			i += 1
		end
		puts
	end

end
