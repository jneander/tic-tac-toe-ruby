require 'minimax_cache'

class Minimax
  attr_accessor :min_mark, :max_mark, :depth_limit
  attr_reader :current_depth, :cache

  def initialize
    @depth_limit = 0
    @current_depth = 0
    @cache = MinimaxCache.new
  end

  def score_moves(board, current_mark)
    map = scores(board, current_mark)
    map.inject({}) {|result, (key, value)|
      result[key] = value.nil? ? 0 : value
      result
    }
  end

  def scores(board, current_mark)
    score_map = Hash.new

    board.spaces_with_mark(Board::BLANK).each do |space|
      board.make_mark(space, current_mark)

      if @cache.scored?(board.spaces)
        score_map[space] = @cache.get_score(board.spaces)
      else
        score_map[space] = score(board, current_mark)
      end

      board.make_mark(space, Board::BLANK)
      break if score_map[space] == target_score(current_mark)
    end

    score_map
  end

  def score(board, current_mark)
    score = win_score(board)

    if score.nil? && @current_depth < @depth_limit
      @current_depth += 1
      next_mark = current_mark.eql?(@min_mark) ? @max_mark : @min_mark
      space_scores = scores(board, next_mark)

      if space_scores.has_value?(target_score(next_mark))
        score = target_score(next_mark)
      elsif space_scores.has_value?(nil)
        score = nil
      else
        score = space_scores.values.
          __send__(next_mark.eql?(@max_mark) ? :max : :min)
      end

      @current_depth -= 1
    end

    @cache.add_score(board.spaces.clone, score) if not score.nil?
    score
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

  def set_depth_limit(board)
    @depth_limit = {3 => 10, 4 => 3}[board.size]
  end
end
