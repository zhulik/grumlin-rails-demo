# frozen_string_literal: true

class CategoriesController < ApplicationController
  REPOSITORY = CategoryRepository.new

  rescue_from StopIteration do
    render json: { error: "not_found" }, status: :not_found
  end

  def index
    render json: REPOSITORY.all
  end

  def show
    render json: REPOSITORY.find(params[:id])
  end

  def create
    render json: REPOSITORY.add(**category_params)
  end

  def update
    render json: REPOSITORY.update(params[:id], **category_params)
  end

  def destroy
    render json: REPOSITORY.drop(params[:id])
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
