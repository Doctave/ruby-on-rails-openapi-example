# Coffee Shop Rails OpenAPI Demo

```shell
rails new coffee_shop --api
```

```shell
./bin/rails g model Order kind price:integer customer
```

```shell
./bin/rails g controller Api::Orders
```

```ruby
Rails.application.routes.draw do

  namespace :api do
    resources :orders, :orders
  end
end
```

```ruby
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
  end
```

```shell
curl -XPOST -H 'Content-Type: application/json' -d '{"order": {"price": 2.3, "customer": "Nik", "kind": "Espresso"}}' localhost:3000/api/orders
```
