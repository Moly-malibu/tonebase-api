require 'rails_helper'

RSpec.describe Video, type: :model do
  it { should serialize(:tags).as(Array) }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:instrument) }

    it { should have_many(:video_parts).dependent(:destroy) }
    it { should have_many(:video_scores).dependent(:destroy) }

    it { should have_many(:user_favorite_videos).dependent(:destroy) }
    it { should have_many(:favorited_by_users).through(:user_favorite_videos) }

    it { should have_many(:user_view_videos).dependent(:destroy) }
    it { should have_many(:viewed_by_users).through(:user_view_videos) }

    it { should have_many(:notifications).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:instrument) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }

    context "uniqueness" do
      subject { build(:video) }
      it { should validate_uniqueness_of(:title).scoped_to(:user_id) }
    end
  end

  describe "class methods" do
    describe ".tagged" do
      before(:each) do
        create(:video, :tagged)
        create_list(:video, 5)
      end

      it "should return videos that have one or more tags" do
        expect(Video.tagged.count).to eql(1)
      end
    end

    describe ".untagged" do
      before(:each) do
        create(:video, :tagged)
        create_list(:video, 5)
      end

      it "should return videos that have no tags" do
        expect(Video.untagged.count).to eql(5)
      end
    end
  end

  describe "call-backs" do
    describe "after_create " do
      describe "#broadcast_new_video_event_to_artist_followers" do
        let!(:nonfollower){ create(:user) }
        let(:artist){ create(:artist, :with_followers)}
        let(:video){ create(:video, :with_callbacks, user: artist)}

        it "should create a new notification" do
          expect{ video }.to change{ Notification.count }.by(1)
        end

        it "should notify all the artist's followers" do
          expect{ video }.to change{ UserNotification.count }.by(artist.followers.count)
        end
      end
    end
  end
end
