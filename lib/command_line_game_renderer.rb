class CommandLineGameRenderer
  def set_output(stream)
    @out = stream
  end

  def board_to_ascii(board, hash)
    board.spaces.each_slice(board.size).collect {|row|
      row.collect {|symbol| hash[symbol]}.join("|")}
  end
end
