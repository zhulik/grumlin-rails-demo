# frozen_string_literal: true

class ProductsController < ApplicationController
  REPOSITORY = ProductRepository.new

  def index
    render json: REPOSITORY.all(**params.permit(category_ids: []).to_h.symbolize_keys)
  end

  def show
    render json: REPOSITORY.find(params[:id])
  end

  def create
    render json: REPOSITORY.add(**product_params)
  end

  def update
    render json: REPOSITORY.update(params[:id], **product_params)
  end

  def destroy
    render json: REPOSITORY.drop(params[:id])
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, category_ids: [])
  end
end
