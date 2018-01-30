require "rails_helper"

RSpec.describe Company, type: :model do
  it "should save with valid attributes" do
    company = build(:company)
    expect(company.valid?).to be true
    expect(company.save).to be true
  end
end
