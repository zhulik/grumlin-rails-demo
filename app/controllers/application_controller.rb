# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from StopIteration do
    render json: { error: "not_found" }, status: :not_found
  end
end
