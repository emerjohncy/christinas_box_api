require 'rails_helper'

RSpec.describe Category, type: :model do
  subject { Category.new(name: "Anklets", status: "Inactive") }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a name" do
    subject.name=nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a status" do
    subject.status=nil
    expect(subject).to_not be_valid
  end

  it "is not valid with a duplicate name (case-insensitive)" do
    subject.save
    duplicate_category = Category.new(name: "anklets", status: "Active")
    expect(duplicate_category).to_not be_valid
  end

  it "is not valid if status is not either Active or Inactive" do
    subject.status = "Invalid Status"
    expect(subject).to_not be_valid
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
end
