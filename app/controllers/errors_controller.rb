class ErrorsController < ApplicationController
  def not_found
    @widgets_mode = true
    render status: 404
  end

  def server_error
    @widgets_mode = true
    render status: 500
  end
end
