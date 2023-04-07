require 'rails_helper'

RSpec.describe "Users API", type: :request do
  # initialize test data
  let!(:users) { create_list(:user, 10)}
  let(:user_id) { users.first.id }

  # Test suite for GET /api/v1/users
  describe "#index GET /api/v1/users" do
    before { get '/api/v1/users' }

    it 'returns users' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end
    
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /api/v1/users/:id
  describe 'GET /api/v1/users/:id' do
    before { get "/api/v1/users/#{user_id}" }

    context 'when the user exists' do
      it 'returns the user' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(user_id)
        expect(json['username']).to eq(User.find(user_id).username)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the user does not exist' do
      let(:user_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match("{\"message\":\"Couldn't find User with 'id'=100\"}")
      end
    end
  end

  # Test suite for POST /api/v1/users
  describe 'POST /api/v1/users' do
    # valid payload
    let(:valid_attributes) {{
      name: 'Anuj Shrestha',
      username: 'anuj8',
      email: 'abc@example.com',
      website: 'http://faketest.com'
    }}

    context 'when the request is valid' do
      before { post '/api/v1/users', params: valid_attributes }

      it 'creates a user' do
        expect(json['name']).to eq('Anuj Shrestha')
        expect(json['username']).to eq('anuj8')
        expect(json['email']).to eq('abc@example.com')
        expect(json['website']).to eq('http://faketest.com')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/users', params: { email: 'anuj' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match("{\"message\":\"Validation failed: Username can't be blank, Email is invalid\"}")
      end
    end
  end

  # Test suite for PUT /api/v1/users/:id
  describe 'PUT /api/v1/users/:id' do
    let(:valid_attributes) { { email: 'anuj@gmail.com' } }
    let(:invalid_attributes) { { email: 'anuj...' } }

    context 'when the record exists' do
      before { put "/api/v1/users/#{user_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).not_to be_empty
        expect(json['email']).to eq('anuj@gmail.com')
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(200)
      end
    end

    context 'updates invalid record' do
      before { put "/api/v1/users/#{user_id}", params: invalid_attributes }

      it 'updates the record' do
        expect(response.body).to match("{\"message\":\"Validation failed: Email is invalid\"}")
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(422)
      end
    end
  end

   # Test suite for DELETE /api/v1/users/:id
   describe 'DELETE /api/v1/users/:id' do
    before { delete "/api/v1/users/#{user_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'check if record got deleted' do
      expect { User.find(user_id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
