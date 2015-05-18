require 'fixtures/event'

class EventsController < ActionController::Base
  include Prospero::Routes.url_helpers

  def model
    @model ||= super
  end

  protected

  def default_render
    render :text => action_name
  end
end
