class CommandLinePrompter
  attr_writer :valid_input

  def set_input_output(instream, outstream)
    @in = instream
    @out = outstream
  end

  def request(*message)
    input = nil
    while not valid_input?(input)
      @out.print(*message)
      input = @in.gets
    end
    input.chomp
  end

  def valid_input?(input)
    input.is_a?(String) && 
      ((not @valid_input.is_a?(Array)) || @valid_input.include?(input))
  end
end
