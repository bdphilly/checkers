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
	 				Piece.new(:red, self, [row, col]) unless (col+row).even?
	 				Piece.new(:black, self, [5+row, col]) unless (col+row).odd?
	 			end
	 		end
		end
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

class Piece

	attr_accessor :board, :color, :pos, :rank

	def initialize(color, board, pos)
		@color, @board, @pos = color, board, pos
		@rank = :soldier # as opposed to a king
		self.board.add_piece(self, pos)
	end

	def render
		{ :red => " R ", :black => " B " }
	end

	def perform_slide(end_pos)
		
		raise "invalid slide move" unless find_sliding_moves.include?(end_pos)

		if find_sliding_moves.include?(end_pos)
			self.board.remove_piece(self, self.pos)
			self.board.add_piece(self, end_pos)
			return true
		end

		false
	end

	def perform_jump(end_pos)
		raise "invalid jump move" unless find_jumping_moves.include?(end_pos)

		if find_jumping_moves.include?(end_pos)
			self.board.remove_piece(self, self.pos)
			self.board.remove_piece(self, find_jumped_pos(end_pos))
			self.board.add_piece(self, end_pos)
			return true
		end

		false
	end

	def find_jumped_pos(end_pos)
		x_coord = (self.pos.first + end_pos.first) / 2
		y_coord = (self.pos.last + end_pos.last) / 2

		[x_coord, y_coord]
	end

	def moves
		moves = find_sliding_moves + find_jumping_moves
	end

	def find_sliding_moves
		[].tap do |moves|
			move_dirs.each do |dx, dy|
				cur_x, cur_y = self.pos
				new_pos = [cur_x + dx, cur_y + dy]

				if self.board.empty?(new_pos) && self.board.valid_pos?(new_pos)
					moves << new_pos
				end

			end
		end
	end

	def find_jumping_moves
		[].tap do |moves|
			move_dirs.each do |dx, dy|
				cur_x, cur_y = self.pos
				adjacent_tile = [cur_x + dx, cur_y + dy]

				if !self.board.empty?(adjacent_tile) && 
						self.board.valid_pos?(adjacent_tile) &&
						self.board[adjacent_tile].color != self.color

						jump_position = [adjacent_tile.first + dx, adjacent_tile.last + dx]

						if self.board.empty?(jump_position) && 
							 self.board.valid_pos?(jump_position)

							 moves << jump_position
						end
				end
			end
		end
	end

	def move_dirs
		if self.rank == :king
			[[-1, -1], [1, -1], [-1, 1], [-1, -1]]
		elsif self.color == :red
			[[1, 1], [1,  -1]]
		else
			[[-1, -1], [-1, 1]]
		end
	end

end

board = Board.new(true)
board.print_board