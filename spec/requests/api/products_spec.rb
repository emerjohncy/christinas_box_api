require 'rails_helper'

RSpec.describe "Products", type: :request do
  let!(:category1) { Category.create!(name: "Pendants") }
  let!(:product1) { Product.create!(name: "Gold Pendant", description: "A beautiful gold pendant", price: 5000.00, category: category1) }
  let!(:product2) { Product.create!(name: "Silver Pendant", description: "A beautiful silver pendant", price: 1500.00, category: category1) }

  let!(:category2) { Category.create!(name: "Anklets") }
  let!(:product3) { Product.create!(name: "Gold Anklet", description: "A beautiful gold anklet", price: 5000.00, category: category2) }
  let!(:product4) { Product.create!(name: "Silver Anklet", description: "A beautiful silver anklet", price: 1500.00, category: category2) }


  describe "GET /categories/:category_id/products" do
    it "returns a successful response" do
      get api_v1_category_products_path(category1)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Gold Pendant")
      expect(response.body).to include("Silver Pendant")
      expect(category1.products.count).to eq(2)
    end

    it "returns not found if category param does not exist" do
      get api_v1_category_products_path(9999)

      expect(response).to have_http_status(:not_found)
      expect(response.body).to include("Error")
      expect(response.body).to include("Category not found")
    end
  end

  describe "GET /products" do
    it "returns a successful response" do
      get api_v1_products_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Gold Pendant")
      expect(response.body).to include("Silver Pendant")
      expect(response.body).to include("Gold Anklet")
      expect(response.body).to include("Silver Anklet")
      expect(Product.count).to eq(4)
    end
  end

  describe "GET /categories/:category_id/products/:id" do
    it "returns a successful response" do
      get api_v1_category_product_path(category1, product1)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Gold Pendant")
      expect(response.body).to include("A beautiful gold pendant")
      # expect(response.body).to include(5000)
    end

    it "returns not found if category param does not exist" do
      get api_v1_category_product_path(9999, product1)

      expect(response).to have_http_status(:not_found)
      expect(response.body).to include("Error")
      expect(response.body).to include("Category not found")
    end

    it "returns not found if product param does not exist" do
      get api_v1_category_product_path(category1, 9999)

      expect(response).to have_http_status(:not_found)
      expect(response.body).to include("Error")
      expect(response.body).to include("Product not found")
    end
  end

  describe "GET /products/:id" do
    it "returns a successful response" do
      get api_v1_product_path(product1)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Gold Pendant")
      expect(response.body).to include("A beautiful gold pendant")
      # expect(response.body).to include(5000)
    end

    it "returns not found if product param does not exist" do
      get api_v1_product_path(id: 9999)

      expect(response).to have_http_status(:not_found)
      expect(response.body).to include("Error")
      expect(response.body).to include("Product not found")
    end
  end

  describe "POST /categories/:category_id/products" do
    context "with valid parameters" do
      it "creates a new product" do
        expect {
          post api_v1_category_products_path(category1), params: { product: { name: "Pearl Necklace", description: "A beautiful pearl necklace", price: 5500.00 } }
        }.to change(Product, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(response.body).to include("Pearl Necklace")
        expect(response.body).to include("Success")
        expect(response.body).to include("Product was created successfully.")
        expect(category1.products.count).to eq(3)
      end
    end

    context "with invalid parameters" do
      it "does not create a new product if name is empty" do
        expect {
          post api_v1_category_products_path(category1), params: { product: { name: "", description: "A beautiful pearl necklace", price: 5500.00 } }
        }.to_not change(Product, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Error")
        expect(response.body).to include("Name can't be blank")
        expect(category1.products.count).to eq(2)
      end

      it "does not create a new product if description is empty" do
        expect {
          post api_v1_category_products_path(category1), params: { product: { name: "Pearl Necklace", description: "", price: 5500.00 } }
        }.to_not change(Product, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Error")
        expect(response.body).to include("Description can't be blank")
        expect(category1.products.count).to eq(2)
      end

      it "does not create a new product if price is empty" do
        expect {
          post api_v1_category_products_path(category1), params: { product: { name: "Pearl Necklace", description: "A beautiful pearl necklace", price: nil } }
        }.to_not change(Product, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Error")
        expect(response.body).to include("Price can't be blank")
        expect(category1.products.count).to eq(2)
      end

      it "does not create a new product if price is zero" do
        expect {
          post api_v1_category_products_path(category1), params: { product: { name: "Pearl Necklace", description: "A beautiful pearl necklace", price: 0 } }
        }.to_not change(Product, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Error")
        expect(response.body).to include("Price must be greater than 0")
        expect(category1.products.count).to eq(2)
      end

      it "does not create a new product if price is less than zero" do
        expect {
          post api_v1_category_products_path(category1), params: { product: { name: "Pearl Necklace", description: "A beautiful pearl necklace", price: -5500 } }
        }.to_not change(Product, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Error")
        expect(response.body).to include("Price must be greater than 0")
        expect(category1.products.count).to eq(2)
      end

      it "does not create a new product if price is not a number" do
        expect {
          post api_v1_category_products_path(category1), params: { product: { name: "Pearl Necklace", description: "A beautiful pearl necklace", price: "five thousand" } }
        }.to_not change(Product, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Error")
        expect(response.body).to include("Price is not a number")
        expect(category1.products.count).to eq(2)
      end

      it "does not create a new product if params[:category_id] does not exist" do
        expect {
          post api_v1_category_products_path(999), params: { product: { name: "Pearl Necklace", description: "A beautiful pearl necklace", price: 5500.00 } }
        }.to_not change(Product, :count)
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include("Error")
        expect(response.body).to include("Category not found")
        expect(category1.products.count).to eq(2)
      end
    end

    describe "PATCH /categories/:category_id/products/:id" do
      context "with valid parameters" do
        it "updates the name of the product" do
          patch api_v1_category_product_path(category1, product1), params: { product: { name: "Updated Name" } }
          product1.reload

          expect(product1.name).to eq("Updated Name")
          expect(response).to have_http_status(:ok)
          expect(response.body).to include("Success")
          expect(response.body).to include("Product was updated successfully.")
        end

        it "updates the description of the product" do
          patch api_v1_category_product_path(category1, product1), params: { product: { description: "Updated Description" } }
          product1.reload

          expect(product1.description).to eq("Updated Description")
          expect(response).to have_http_status(:ok)
          expect(response.body).to include("Success")
          expect(response.body).to include("Product was updated successfully.")
        end

        it "updates the price of the product" do
          patch api_v1_category_product_path(category1, product1), params: { product: { price: 10000 } }
          product1.reload

          expect(product1.price).to eq(10000)
          expect(response).to have_http_status(:ok)
          expect(response.body).to include("Success")
          expect(response.body).to include("Product was updated successfully.")
        end

        it "updates the category of the product" do
          patch api_v1_category_product_path(category1, product1), params: { product: { category_id: category2.id } }
          product1.reload

          expect(product1.category).to eq(category2)
          expect(response).to have_http_status(:ok)
          expect(response.body).to include("Success")
          expect(response.body).to include("Product was updated successfully.")
        end
      end

      context "with invalid parameters" do
        it "does not update if name is empty" do
          patch api_v1_category_product_path(category1, product1), params: { product: { name: "" } }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("Error")
          expect(response.body).to include("Name can't be blank")
          expect(product1.name).to eq("Gold Pendant")
        end

        it "does not update if description is empty" do
          patch api_v1_category_product_path(category1, product1), params: { product: { description: "" } }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("Error")
          expect(response.body).to include("Description can't be blank")
          expect(product1.description).to eq("A beautiful gold pendant")
        end

        it "does not update if price is empty" do
          patch api_v1_category_product_path(category1, product1), params: { product: { price: nil } }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("Error")
          expect(response.body).to include("Price can't be blank")
          expect(product1.price).to eq(5000.00)
        end

        it "does not update if price is zero" do
          patch api_v1_category_product_path(category1, product1), params: { product: { price: 0 } }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("Error")
          expect(response.body).to include("Price must be greater than 0")
          expect(product1.price).to eq(5000.00)
        end

        it "does not update if price is less than zero" do
          patch api_v1_category_product_path(category1, product1), params: { product: { price: -10000 } }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("Error")
          expect(response.body).to include("Price must be greater than 0")
          expect(product1.price).to eq(5000.00)
        end

        it "does not update if price is not a number" do
          patch api_v1_category_product_path(category1, product1), params: { product: { price: "ten thousand" } }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("Error")
          expect(response.body).to include("Price is not a number")
          expect(product1.price).to eq(5000.00)
        end

        it "does not update if category_id does not exist" do
          patch api_v1_category_product_path(category1, product1), params: { product: { category_id: 999 } }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("Error")
          expect(response.body).to include("Category must exist")
          expect(product1.category).to eq(category1)
        end

        it "returns not found if params[:category_id] does not exist" do
          patch api_v1_category_product_path(999, product1), params: { product: { name: "Updated Name" } }

          expect(response).to have_http_status(:not_found)
          expect(response.body).to include("Error")
          expect(response.body).to include("Category not found")
        end

        it "returns not found if params[:id] does not exist" do
          patch api_v1_category_product_path(category1, 999), params: { product: { name: "Updated Name" } }

          expect(response).to have_http_status(:not_found)
          expect(response.body).to include("Error")
          expect(response.body).to include("Product not found")
        end
      end
    end

    describe "DELETE /categories/:category_id/products/:id" do
      it "deletes the product" do
        expect {
          delete api_v1_category_product_path(category1, product1)
        }.to change(Product, :count).by(-1)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Success")
        expect(response.body).to include("Product was deleted successfully.")
        expect(Product.exists?(product1.id)).to be false
      end

      it "returns not found if params[:category_id] does not exist" do
        expect {
          delete api_v1_category_product_path(999, product1)
        }.to_not change(Product, :count)

        expect(response).to have_http_status(:not_found)
        expect(response.body).to include("Error")
        expect(response.body).to include("Category not found")
      end

      it "returns not found if params[:id] does not exist" do
        expect {
          delete api_v1_category_product_path(category1, 999)
        }.to_not change(Product, :count)

        expect(response).to have_http_status(:not_found)
        expect(response.body).to include("Error")
        expect(response.body).to include("Product not found")
      end

      it "does not delete its associated category if a product is destroyed" do
        expect {
          delete api_v1_category_product_path(category1, product1)
        }.to_not change(Category, :count)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Success")
        expect(response.body).to include("Product was deleted successfully.")
        expect(Category.exists?(category1.id)).to be true
      end

      context "when deletion fails" do
        before do
          allow_any_instance_of(Product).to receive(:destroy).and_return(false)
          delete api_v1_category_product_path(product1.category_id.to_s, product1.id.to_s)
        end

        it "returns an error response" do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("Error")
          expect(response.body).to include("Failed to delete product")
        end
      end
    end
  end
end
