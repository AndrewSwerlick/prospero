require 'functional/fixtures/record'

class TestController < ActionController::Base
  include Prospero::Routes.url_helpers

  def model
    @model ||= Record.new
  end

  protected

  def default_render
    render :text => action_name
  end
end
