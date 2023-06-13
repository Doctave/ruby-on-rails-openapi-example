# Generating a OpenAPI spec from a Ruby on Rails API

This is a demo for how to generate an OpenAPI spec from a Ruby on Rails API.

Read the associated blog post: [Generating an OpenAPI/Swagger spec from a Ruby on Rails API](https://www.doctave.com/blog/generate-openapi-swagger-spec-from-ruby-on-rails)

It uses [`rswag`](https://github.com/rswag/rswag) to create tests that verify the behaviour of the API, and generate the spec for you.

Some features of the spec:

- Operations grouped under the `Orders` tag
- Automatic example generation from the tests
- Descriptions for all operations
- Reusable `order` component

## How to use this demo

First, make sure you're running a recent Ruby version.

Then:

```shell
./bin/bundle install
```

To run the tests for the `OrdersController`:

```shell
bundle exec rspec ./spec/requests/api/orders_spec.rb
```

Finally, to generate the spec, run:

```shell
SWAGGER_DRY_RUN=0 RAILS_ENV=test ./bin/rails rswag
```

## The spec

```yaml
---
openapi: 3.0.1
info:
  title: Coffee Shop API V1
  version: v1
paths:
  "/api/orders":
    get:
      summary: List orders
      tags:
      - Orders
      description: List all orders in the system
      responses:
        '200':
          description: successful
          content:
            application/json:
              examples:
                test_example:
                  value:
                  - id: 1
                    kind: Latte
                    price: '2.8'
                    customer: Bob
                  - id: 2
                    kind: Espresso
                    price: '0.1'
                    customer: Eve
              schema:
                type: array
                items:
                  "$ref": "#/components/schemas/order"
    post:
      summary: create order
      tags:
      - Orders
      description: 'Create a new order. **NOTE**: Price is set by customer! Do not
        go to production.'
      parameters: []
      responses:
        '200':
          description: successful
          content:
            application/json:
              examples:
                test_example:
                  value:
                    id: 1
                    kind: Espresso
                    price: '0.2'
                    customer: Eve
              schema:
                "$ref": "#/components/schemas/order"
      requestBody:
        content:
          application/json:
            schema:
              "$ref": "#/components/schemas/order"
  "/api/orders/{id}":
    parameters:
    - name: id
      in: path
      description: The ID for the order
      required: true
      schema:
        type: integer
    get:
      summary: show order
      description: Get the details for a particular order
      responses:
        '200':
          description: successful
          content:
            application/json:
              examples:
                test_example:
                  value:
                    id: 1
                    kind: Latte
                    price: '0.8'
                    customer: Bob
              schema:
                "$ref": "#/components/schemas/order"
        '404':
          description: not found
          content:
            application/json:
              examples:
                test_example:
                  value:
                    error: Order not found
              schema:
                "$ref": "#/components/schemas/not_found"
components:
  schemas:
    not_found:
      type: object
      properties:
        error:
          type: string
    order:
      type: object
      required:
      - kind
      - price
      - customer
      properties:
        kind:
          type: string
          example: Espresso
        price:
          type: string
          pattern: "^\\d*\\.?\\d*$"
          example: '1.2'
          description: Price, formatted as a string
        customer:
          type: string
          example: Alice
servers:
- url: https://{defaultHost}
  variables:
    defaultHost:
      default: www.example.com
```
