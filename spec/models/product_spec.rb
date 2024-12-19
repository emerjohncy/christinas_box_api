require 'rails_helper'

RSpec.describe Product, type: :model do
  let!(:category) { Category.create!(name: "Necklaces") }
  subject { Product.new(name: "Gold Necklace", description: "A beautiful gold necklace", price: 12000.00, category: category) }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "belongs to a category" do
    expect(subject.category).to eq(category)
  end

  it "is not valid without a name" do
    subject.name=nil
    expect(subject).to_not be_valid
    expect(subject.errors[:name]).to include("can't be blank")
  end

  it "is not valid without a description" do
    subject.description=nil
    expect(subject).to_not be_valid
    expect(subject.errors[:description]).to include("can't be blank")
  end

  it "is not valid without a price" do
    subject.price=nil
    expect(subject).to_not be_valid
    expect(subject.errors[:price]).to include("can't be blank")
  end

  it "is not valid if price is zero" do
    subject.price=0
    expect(subject).to_not be_valid
    expect(subject.errors[:price]).to include("must be greater than 0")
  end

  it "is not valid if price is less than zero" do
    subject.price=-50000.00
    expect(subject).to_not be_valid
    expect(subject.errors[:price]).to include("must be greater than 0")
  end

  it "is not valid if price is not a number" do
    subject.price="twenty thousand pesos"
    expect(subject).to_not be_valid
    expect(subject.errors[:price]).to include("is not a number")
  end


  it "is not valid without a category" do
    subject.category=nil
    expect(subject).to_not be_valid
    expect(subject.errors[:category]).to include("must exist")
  end
end
