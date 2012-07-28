class CommandLinePrompter
  attr_writer :valid_input

  def set_input_output(instream, outstream)
    @in = instream
    @out = outstream
  end

  def request(*message)
    @out.print(*message)
    input = @in.gets.chomp
    input if valid_input?(input)
  end

  def valid_input?(input)
    input.is_a?(String) && 
      ((not @valid_input.is_a?(Array)) || @valid_input.include?(input))
  end
end
