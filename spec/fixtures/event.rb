require 'active_model'

class Event
  include ActiveModel::Model

  attr_reader :saved

  attr_accessor :start_date_time
  attr_accessor :name
  attr_accessor :end_date_time

  def id
    1
  end

  def save
    @saved = true
  end

  def self.find(id)
    Event.new
  end
end
