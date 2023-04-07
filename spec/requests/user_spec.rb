require 'rails_helper'

RSpec.describe "Users API", type: :request do
  # initialize test data
  let!(:users) { create_list(:user, 10)}
  let(:user_id) { users.first.id }

  # Test suite for GET /users
  describe "#index GET /users" do
    before { get '/users' }

    it 'returns users' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end
    
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end
