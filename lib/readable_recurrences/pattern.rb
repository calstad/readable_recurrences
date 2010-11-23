class Pattern
  attr_accessor :weeks, :description

  def initialize(opts)
    @weeks = opts[:weeks].map { |w| w - 1}
    @description = opts[:description]
  end

end
