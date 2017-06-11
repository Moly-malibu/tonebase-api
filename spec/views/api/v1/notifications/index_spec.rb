require "rails_helper"
require_relative "../../../../support/api/v1/view"

describe "api/v1/notifications/index.json.jbuilder" do
  before(:each) do
    assign(:notifications, [create(:notification), create(:notification)])
    render
  end

  it "displays advertisers" do
    expect(parsed_view.count).to eql(2)
    parsed_view.each do |advertiser|
      expect(keys_of(advertiser)).to match_array([
        :id,
        :broadcastable_type,
        :broadcastable_id,
        :event,
        :headline,
        :url,
        :notified_users,
        :created_at,
        :updated_at
      ])
    end
  end
end
