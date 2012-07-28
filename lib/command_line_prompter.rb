class CommandLinePrompter
  def set_input_output(instream, outstream)
    @in = instream
    @out = outstream
  end

  def request(message)
    @out.print(message)
  end
end
