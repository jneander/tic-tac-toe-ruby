require 'minimax_cache'

class Minimax
  attr_accessor :min_mark, :max_mark, :depth_limit
  attr_reader :current_depth, :cache

  DEFAULT_LIMIT = 7

  def initialize(depth_limit = DEFAULT_LIMIT)
    @depth_limit = depth_limit
    @current_depth = 0
    @cache = MinimaxCache.new
  end

  def scores(board, current_mark)
    score_map = Hash.new

    board.spaces_with_mark(Board::BLANK).each do |space|
      board.make_mark(space, current_mark)

      if @cache.scored?(board.spaces)
        score_map[space] = @cache.get_score(board.spaces)
      else
        change_depth = @cache.incomplete?(board.spaces) ? false : true
        @current_depth += 1 if change_depth
        score_map[space] = score(board, current_mark)
        @current_depth -= 1 if change_depth
      end

      board.make_mark(space, Board::BLANK)
      break if score_map[space] == target_score(current_mark)
    end

    score_map
  end

  def score(board, current_mark)
    score = win_score(board)

    if score.nil? && @current_depth <= @depth_limit
      next_mark = current_mark.eql?(@min_mark) ? @max_mark : @min_mark

      space_scores = scores(board, next_mark)
      if not space_scores.empty?
        space_scores = space_scores.sort_by {|key, value| value}
        score = next_mark.eql?(@max_mark) ? 
          space_scores.last[1] : space_scores.first[1]
      end
    end

    cache_value = score || :incomplete
    @cache.add_score(board.spaces, cache_value)
    score || 0
  end

  def win_score(board)
    score = nil
    score = 1 if board.winning_solution?(@max_mark)
    score = -1 if board.winning_solution?(@min_mark)
    score
  end

  def target_score(mark)
    mark.eql?(@min_mark) ? -1 : 1
  end
end
