class Api::OrdersController < ApplicationController
  def index
    @orders = Order.all

    render json: @orders
  end

  def show
    @order = Order.find(params[:id])

    render json: @order
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Order not found" }, status: :not_found
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      render json: @order
    else
      render json: @order.errors
    end
  end

  private

  def order_params
    params.require(:order).permit(:kind, :price, :customer)
  end
end
