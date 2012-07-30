class CommandLineGameRenderer
  def set_output(stream)
    @out = stream
  end

  def board_to_ascii(board, hash)
    board.spaces.each_slice(board.size).collect {|row|
      row.collect {|symbol| hash[symbol]}.join("|")}
  end

  def available_spaces_to_ascii(board)
    board.spaces.collect.with_index {|space, index|
      space.eql?(Board::BLANK) ? index + 1 : " "
    }.each_slice(board.size).to_a.collect {|row| row.join(" ")}
  end
end
