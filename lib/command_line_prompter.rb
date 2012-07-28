class CommandLinePrompter
  attr_writer :valid_input

  def set_input_output(instream, outstream)
    @in = instream
    @out = outstream
  end

  def request(message)
    @out.print(message)
    @in.gets.chomp
  end
end
