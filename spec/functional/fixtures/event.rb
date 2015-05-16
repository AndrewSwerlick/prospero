class Event
  attr_reader :saved
  @events = {}

  def save
    @saved = true
  end

  def self.find(id)
    Event.new
  end
end
