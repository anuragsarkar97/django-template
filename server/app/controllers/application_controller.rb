# frozen_string_literal: true

class ApplicationController < ActionController::API

  before_action :log_api

  def log_api
    Rails.logger.info "API: #{request.method} #{request.url}"
  end

end
