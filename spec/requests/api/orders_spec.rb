require 'swagger_helper'

RSpec.describe 'api/orders', type: :request do

  path '/api/orders' do

    get('List orders') do
      tags 'Orders'
      consumes 'application/json'
      produces 'application/json'
      description "List all orders in the system"

      response(200, 'successful') do
        schema type: :array, items: { "$ref" => "#/components/schemas/order" }

        let!(:order1) { Order.create(kind: "Latte", price: 2.8, customer: "Bob") }
        let!(:order2) { Order.create(kind: "Espresso", price: 0.1, customer: "Eve") }
        
        after do |example|
          content = example.metadata[:response][:content] || {}
          example_spec = {
            "application/json"=>{
              examples: {
                test_example: {
                  value: JSON.parse(response.body, symbolize_names: true)
                }
              }
            }
          }
          example.metadata[:response][:content] = content.deep_merge(example_spec)
        end

        run_test!
      end
    end

    post('create order') do
      tags 'Orders'
      consumes 'application/json'
      produces 'application/json'
      description "Create a new order. **NOTE**: Price is set by customer! Do not go to production."

      parameter name: :order, in: :body, schema: { "$ref" => "#/components/schemas/order" }

      response(200, 'successful') do
        schema "$ref" => "#/components/schemas/order"

        let!(:order) {
          {
            kind: "Espresso",
            price: 0.2,
            customer: "Eve"
          }
        }
        
        after do |example|
          content = example.metadata[:response][:content] || {}
          example_spec = {
            "application/json"=>{
              examples: {
                test_example: {
                  value: JSON.parse(response.body, symbolize_names: true)
                }
              }
            }
          }
          example.metadata[:response][:content] = content.deep_merge(example_spec)
        end

        run_test!
      end
    end
  end

  path '/api/orders/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'The ID for the order'

    get('show order') do
      description "Get the details for a particular order"

      produces 'application/json'

      response(200, 'successful') do
        schema "$ref" => "#/components/schemas/order"

        let(:order) { Order.create(kind: "Latte", price: 0.8, customer: "Bob") }
        let(:id) { order.id }
        
        after do |example|
          content = example.metadata[:response][:content] || {}
          example_spec = {
            "application/json"=>{
              examples: {
                test_example: {
                  value: JSON.parse(response.body, symbolize_names: true)
                }
              }
            }
          }
          example.metadata[:response][:content] = content.deep_merge(example_spec)
        end

        run_test!
      end

      response(404, 'not found') do
        schema "$ref" => "#/components/schemas/not_found"

        let(:id) { 999999999 }

        after do |example|
          content = example.metadata[:response][:content] || {}
          example_spec = {
            "application/json"=>{
              examples: {
                test_example: {
                  value: JSON.parse(response.body, symbolize_names: true)
                }
              }
            }
          }
          example.metadata[:response][:content] = content.deep_merge(example_spec)
        end

        run_test!
      end
    end
  end
end
