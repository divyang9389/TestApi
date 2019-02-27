require 'rails_helper'

RSpec.describe 'POST /signup', type: :request do
  context 'when user is unauthenticated' do
    before  do
      post '/signup', params: {
          user: {
            email: 'test@example.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
    end

    it 'returns 200' do
      expect(response.status).to eq 200
    end

    it 'returns a new user' do
      current_user = JSON.parse(response.body)
      expect(current_user["email"]).to eq 'test@example.com'
    end
  end

  context 'when user already exists' do
    before do
      User.create(email: 'test@example.com',
            password: 'password',
            password_confirmation: 'password')
      post '/signup', params: {
          user: {
            email: 'test@example.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
    end

    it 'returns bad request status' do
      expect(response.status).to eq 400
    end

    it 'returns validation errors' do
      res = JSON.parse(response.body)
      expect(res["errors"].first['title']).to eq('Bad Request')
    end
  end
end