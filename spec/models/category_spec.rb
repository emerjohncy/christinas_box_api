require 'rails_helper'

RSpec.describe Category, type: :model do
  subject { Category.new(name: "Anklets", status: "Inactive") }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a name" do
    subject.name=nil
    expect(subject).to_not be_valid
    expect(subject.errors[:name]).to include("can't be blank")
  end

  it "is not valid without a status" do
    subject.status=nil
    expect(subject).to_not be_valid
    expect(subject.errors[:status]).to include("can't be blank")
  end

  it "is not valid with a duplicate name (case-insensitive)" do
    subject.save
    duplicate_category = Category.new(name: "anklets", status: "Active")
    expect(duplicate_category).to_not be_valid
    expect(duplicate_category.errors[:name]).to include("has already been taken")
  end

  it "is not valid if status is not either Active or Inactive" do
    subject.status = "Invalid Status"
    expect(subject).to_not be_valid
    expect(subject.errors[:status]).to include("is not included in the list")
  end

  it "is valid even without status after initialize" do
    category = Category.new(name: "Anklets")
    expect(category).to be_valid
  end

  it "sets the status to default value Inactive if status is nil after initialize" do
    category = Category.new(name: "Anklets")
    expect(category.status).to eq("Inactive")
  end

  it "does not overwrite the provided status" do
    category = Category.new(name: "Anklets", status: "Active")
    expect(category.status).to eq("Active")
  end

  context "associations" do
    let!(:product1) { Product.create!(name: "Gold Necklace", description: "A beautiful gold necklace", price: 12000.00, category: subject) }
    let!(:product2) { Product.create!(name: "Silver Necklace", description: "A beautiful silver necklace", price: 8000.00, category: subject) }

    it "has many products" do
      expect(subject.products).to include(product1, product2)
    end

    it "does not have products if none are created" do
      empty_category = Category.create!(name: "Pendants")
      expect(empty_category.products).to be_empty
    end

    it "deletes associated products when the category is destroyed" do
      expect { subject.destroy }.to change(Product, :count).by(-2)
    end

    it "does not leave orphaned products when a category is destroyed" do
      subject.destroy
      expect(Product.exists?(product1.id)).to be false
      expect(Product.exists?(product2.id)).to be false
    end
  end
end
