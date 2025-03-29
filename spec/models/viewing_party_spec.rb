require 'rails_helper'

RSpec.describe ViewingParty, type: :model do
  describe "validations" do
    it { should have_many(:viewing_party_users).dependent(:destroy) }
    it { should have_many(:users).through(:viewing_party_users) }
    it { should belong_to(:host).class_name('User') }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
    it { should validate_presence_of(:movie_id) }
    it { should validate_numericality_of(:movie_id).only_integer.is_greater_than(0) }
    it { should validate_presence_of(:movie_title) }
  end

  describe 'custom validations' do
    let(:host) { create(:user) }
    let(:valid_attributes) do
      {
        name: "Shank Shaw for Redemption Night",
        start_time: DateTime.now,
        end_time: DateTime.now + 5.hours,
        movie_id: 278, 
        movie_title: "The Shawshank Redemption",
        host: host
      }
    end

    let(:missing_start_time) { valid_attributes.except(:start_time) }
    let(:missing_end_time) { valid_attributes.except(:end_time) }
    let(:end_before_start) { valid_attributes.merge(end_time: DateTime.now - 1.hour) }
    let(:short_duration) { valid_attributes.merge(end_time: valid_attributes[:start_time] + 30.minutes) }
    let(:invalid_invitee) { valid_attributes.merge(invitees: [99999]) }

    it 'is valid with valid attributes' do
      viewing_party = ViewingParty.create(valid_attributes)
      expect(viewing_party).to be_valid
    end

    context 'when required attributes are missing' do
      it 'is invalid if start_time is blank' do
        viewing_party = ViewingParty.create(missing_start_time)
        expect(viewing_party).not_to be_valid
        expect(viewing_party.errors[:start_time]).to include("can't be blank")
      end

      it 'is invalid if end_time is blank' do
        viewing_party = ViewingParty.create(missing_end_time)
        expect(viewing_party).not_to be_valid
        expect(viewing_party.errors[:end_time]).to include("can't be blank")
      end
    end

    context 'when given incorrect times' do
      it 'is invalid if end_time is before start_time' do
        viewing_party = ViewingParty.create(end_before_start)
        expect(viewing_party).not_to be_valid
        expect(viewing_party.errors[:end_time]).to include("must be after the start time")
      end

      it 'is invalid if duration is less than movie run time' do
        viewing_party = ViewingParty.create(short_duration)
        expect(viewing_party).not_to be_valid
        expect(viewing_party.errors[:end_time]).to include("#{valid_attributes[:name]} party must be at least as long as #{valid_attributes[:movie_title]} film")
      end
    end
  end

  context 'when invitees include an invalid user ID' do
    it 'is invalid if an invitee does not exist' do
      viewing_party = ViewingParty.new(
        name: "Shank Shaw for Redemption Night",
        start_time: Time.now,
        end_time: Time.now + 2.hours,
        movie_id: 278,
        movie_title: "The Shawshank Redemption",
        host_id: 210
      )
      invalid_user_id = 99999
      viewing_party.viewing_party_users.new(user_id: invalid_user_id)

      expect(viewing_party).not_to be_valid
      expect(viewing_party.errors[:invitees]).to include("contains invalid users")
    end
  end
end
