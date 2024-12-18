require 'rails_helper'

RSpec.describe "Categories", type: :request do
  let!(:active_category) { Category.create!(name: "Necklaces", status: "Active") }
  let!(:inactive_category) { Category.create!(name: "Earrings", status: "Inactive") }

  describe "GET /categories" do
    it "returns a successful response" do
      get api_v1_categories_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Necklaces")
      expect(response.body).to include("Earrings")
      expect(Category.count).to eq(2)
    end
  end

  describe "GET /categories/:id" do
    it "returns the correct category" do
      get api_v1_category_path(active_category)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Necklaces")
    end

    it "returns not found if category does not exist" do
      get api_v1_category_path(999999)

      expect(response).to have_http_status(:not_found)
      expect(response.body).to include("Error")
      expect(response.body).to include("Category not found")
    end
  end

  describe "POST /categories" do
    context "with valid parameters" do
      it "creates a new category" do
      expect {
        post api_v1_categories_path, params: { category: { name: "Bracelets", status: "Active" } }
      }.to change(Category, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(response.body).to include("Bracelets")
      expect(response.body).to include("Success")
      expect(response.body).to include("Category was created successfully.")
      end
    end

    context "with invalid parameters" do
      it "does not create a new category if name is empty" do
        expect {
          post api_v1_categories_path, params: { category: { name: "", status: "Active" } }
        }.to_not change(Category, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Error")
        expect(response.body).to include("Name can't be blank")
      end

      it "does not create a new category if name already exists" do
        expect {
          post api_v1_categories_path, params: { category: { name: "Necklaces", status: "Active" } }
        }.to_not change(Category, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Error")
        expect(response.body).to include("Name has already been taken")
      end

      it "does not create a new category if name already exists and ignores case sensitivity" do
        expect {
          post api_v1_categories_path, params: { category: { name: "necklaces", status: "Active" } }
        }.to_not change(Category, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Error")
        expect(response.body).to include("Name has already been taken")
      end

      it "does not create a new category if status is neither Active nor Inactive" do
        expect {
          post api_v1_categories_path, params: { category: { name: "Rings", status: "Invalid Status" } }
        }.to_not change(Category, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Error")
        expect(response.body).to include("Status is not included in the list")
      end
    end
  end

  describe "PATCH /categories/:id" do
    context "with valid parameters" do
      it "updates the name of category" do
        patch api_v1_category_path(active_category), params: { category: { name: "Updated Necklaces" } }
        active_category.reload

        expect(active_category.name).to eq("Updated Necklaces")
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Success")
        expect(response.body).to include("Category was updated successfully.")
      end

      it "updates the status of category" do
        patch api_v1_category_path(inactive_category), params: { category: { status: "Active" } }
        inactive_category.reload

        expect(inactive_category.status).to eq("Active")
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Success")
        expect(response.body).to include("Category was updated successfully.")
      end
    end

    context "with invalid parameters" do
      it "does not update if name is empty" do
        patch api_v1_category_path(active_category), params: { category: { name: "" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Error")
        expect(response.body).to include("Name can't be blank")
      end

      it "does not update if name already exists" do
        patch api_v1_category_path(active_category), params: { category: { name: "Earrings" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Error")
        expect(response.body).to include("Name has already been taken")
      end

      it "does not update if name already exists regardless of its case" do
        patch api_v1_category_path(active_category), params: { category: { name: "earrings" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Error")
        expect(response.body).to include("Name has already been taken")
      end

      it "does not update if status is neither Active nor Inactive" do
        patch api_v1_category_path(active_category), params: { category: { status: "Invalid Status" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Error")
        expect(response.body).to include("Status is not included in the list")
      end

      it "return not found if category does not exist" do
        patch api_v1_category_path(999999), params: { category: { Name: "Updated Name" } }

        expect(response).to have_http_status(:not_found)
        expect(response.body).to include("Error")
        expect(response.body).to include("Category not found")
      end
    end
  end

  describe "DELETE /categories/:id" do
    it "deletes the category" do
      expect {
        delete api_v1_category_path(active_category)
      }.to change(Category, :count).by(-1)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Success")
      expect(response.body).to include("Category was deleted successfully.")
    end

    it "returns not found if category does not exist" do
      patch api_v1_category_path(999999)

      expect(response).to have_http_status(:not_found)
      expect(response.body).to include("Error")
      expect(response.body).to include("Category not found")
    end
  end
end
