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

	def perform_moves(move_sequence)
		if valid_move_seq?(move_sequence)
			perform_moves!(move_sequence)
		else
			raise	InvalidMoveError
		end
	end


	def perform_moves!(move_sequence)
		p "MOVE SEQUENCE: #{move_sequence}"
		p move_sequence.flatten.compact.count
		p move_sequence.first
		if move_sequence.flatten.compact.count < 3
			unless self.perform_slide(move_sequence.first) || self.perform_jump(move_sequence.first)
				raise InvalidMoveError
			end
		else
			move_sequence.each do |move_position|
				# if move_position == [6,3]
				# 	debugger
				# end
				p "SELF.POS"
				p self.pos	
				p move_position
				p "jumping moves:#{self.find_jumping_moves}"
				# p perform_jump(move_position)
				# self.perform_jump(move_position)
				# self.pos = move_position
				raise InvalidMoveError unless self.perform_jump(move_position) 
			end
		end
	end

	def valid_move_seq?(move_sequence)
		p "MOVE SEQUENCE: #{move_sequence}"
		dupped_board = self.board.dup_board

		begin
			puts "step A"
			dupped_board[self.pos].perform_moves!(move_sequence)
		rescue InvalidMoveError => e
			puts e
			puts "step B"
			false
		else
			true
		end
	end

	def perform_slide(end_pos)
		# p "FINDING SLIDE MOVES"
		# p find_sliding_moves
		# puts
		# raise "invalid slide move" unless find_sliding_moves.include?(end_pos)

		if find_sliding_moves.include?(end_pos)
			self.board.remove_piece(self, self.pos)
			self.board.add_piece(self, end_pos)
			self.pos = end_pos
			return true
		end

		false
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

	def perform_jump(end_pos)
		# raise "invalid jump move" unless find_jumping_moves.include?(end_pos)
		if find_jumping_moves.include?(end_pos)
			puts 'HELLO'
			self.board.add_piece(self, end_pos)
			self.board.remove_piece(self, self.pos)
			self.board.remove_piece(self, find_jumped_pos(end_pos))
			self.pos = end_pos
			# puts self.pos
			return true
		end

		false
	end

	def find_jumped_pos(end_pos)
		x_coord = (self.pos.first + end_pos.first) / 2
		y_coord = (self.pos.last + end_pos.last) / 2

		[x_coord, y_coord]
	end

	def find_jumping_moves
		[].tap do |moves|
			move_dirs.each do |dx, dy|
				cur_x, cur_y = self.pos
				adjacent_tile = [cur_x + dx, cur_y + dy]

				if !self.board.empty?(adjacent_tile) && 
						self.board.valid_pos?(adjacent_tile) &&
						self.board[adjacent_tile].color != self.color

						jump_position = [adjacent_tile.first + dx, adjacent_tile.last + dy]

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

class InvalidMoveError < RuntimeError
	puts "Sorry buddy, that's an invalid move!"
end