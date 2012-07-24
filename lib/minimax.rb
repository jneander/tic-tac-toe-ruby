class Minimax
  attr_accessor :min_mark, :max_mark

  def score(board,current_mark)
    score = 0
    score = 1 if board.winning_solution?(@max_mark)
    score = -1 if board.winning_solution?(@min_mark)

    if score == 0
      next_mark = current_mark == @min_mark ? @max_mark : @min_mark

      space_scores = scores(board, next_mark)
      if not space_scores.empty?
        space_scores = space_scores.sort_by {|key,value| value}.reverse
        score = next_mark == @max_mark ? 
          space_scores.first[1] : space_scores.last[1]
      end
    end

    score
  end

  def scores(board, current_mark)
    target_score = current_mark == @min_mark ? -1 : 1
    score_hash = Hash.new

    board.spaces_with_mark(Board::BLANK).each do |space|
      board.make_mark(space, current_mark)
      score_hash[space] = score(board, current_mark)
      board.make_mark(space, Board::BLANK)
      break if score_hash[space] == target_score
    end

    score_hash
  end
end
