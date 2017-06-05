require "rails_helper"
require_relative "../../../../support/api/v1/view"

describe "api/v1/users/index.json.jbuilder" do
  before(:each) do
    assign(:users, [create(:user), create(:user)])
    render
  end

  it "displays users" do
    expect(parsed_view.count).to eql(2)
    parsed_view.each do |user|
      expect(keys_of(user)).to match_array([
        :id, :email, :password, :confirmed, :visible, :role, :access_level,
        :first_name, :last_name, :bio, :image_url, :hero_url,
        :follows, :followers,
        :customer_uuid,
        :created_at, :updated_at
      ])
    end
  end
end
