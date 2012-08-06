class CommandLineRenderer
  def set_output(stream)
    @out = stream
  end

  def board_to_ascii(board, hash)
    board.spaces.each_slice(board.size).collect {|row|
      row.collect {|symbol| hash[symbol]}.join("|")}
  end

  def available_spaces_to_ascii(board)
    padding = (board.size**2).to_s.length
    board.spaces.collect.with_index {|space, index|
      "%#{padding}s" % (space.eql?(Board::BLANK) ? index + 1 : " ")
    }.each_slice(board.size).to_a.collect {|row| row.join(" ")}
  end

  def players_as_options(players)
    "[%s]" % players.collect.with_index {|player,index|
      "%d: %s" % [index+1, player]}.join(", ")
  end
end
