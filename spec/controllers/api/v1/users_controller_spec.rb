require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }
  
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe 'PUT #update_profile' do
    let(:valid_attributes) do
      {
        user: {
          name: 'Updated Name',
          email: 'updated@example.com',
          username: 'updated_user',
          phone_number: '+1234567890'
        }
      }
    end

    let(:invalid_attributes) do
      {
        user: {
          email: 'invalid-email'
        }
      }
    end

    context 'with valid parameters' do
      it 'updates the user profile' do
        put :update_profile, params: valid_attributes
        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('Profile updated successfully')
        
        user.reload
        expect(user.name).to eq('Updated Name')
        expect(user.email).to eq('updated@example.com')
        expect(user.username).to eq('updated_user')
        expect(user.phone_number).to eq('+1234567890')
      end

      it 'returns updated user data' do
        put :update_profile, params: valid_attributes
        
        json_response = JSON.parse(response.body)
        expect(json_response['user']).to include(
          'name' => 'Updated Name',
          'email' => 'updated@example.com',
          'username' => 'updated_user',
          'phone_number' => '+1234567890'
        )
      end
    end

    context 'with invalid parameters' do
      it 'returns validation errors' do
        put :update_profile, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('Failed to update profile')
        expect(json_response['errors']).to be_present
      end
    end

    context 'when not authenticated' do
      before { sign_out user }
      
      it 'returns unauthorized' do
        put :update_profile, params: valid_attributes
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT #update_preferences' do
    let(:preferences) do
      {
        user: {
          darkmode: true
        }
      }
    end

    context 'with valid preferences' do
      it 'updates user preferences' do
        put :update_preferences, params: preferences
        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('Preferences updated successfully')
        
        user.reload
        expect(user.darkmode).to be true
      end

      it 'returns updated user data' do
        put :update_preferences, params: preferences
        
        json_response = JSON.parse(response.body)
        expect(json_response['user']['darkmode']).to be true
      end
    end

    context 'when not authenticated' do
      before { sign_out user }
      
      it 'returns unauthorized' do
        put :update_preferences, params: preferences
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT #change_password' do
    let(:valid_password_params) do
      {
        user: {
          current_password: 'password123',
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }
      }
    end

    let(:invalid_current_password) do
      {
        user: {
          current_password: 'wrongpassword',
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }
      }
    end

    let(:mismatched_confirmation) do
      {
        user: {
          current_password: 'password123',
          password: 'newpassword123',
          password_confirmation: 'differentpassword'
        }
      }
    end

    context 'with valid password data' do
      it 'changes the user password' do
        put :change_password, params: valid_password_params
        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('Password changed successfully')
        
        user.reload
        expect(user.valid_password?('newpassword123')).to be true
      end
    end

    context 'with incorrect current password' do
      it 'returns error' do
        put :change_password, params: invalid_current_password
        expect(response).to have_http_status(:unprocessable_entity)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('Current password is incorrect')
      end
    end

    context 'with mismatched password confirmation' do
      it 'returns error' do
        put :change_password, params: mismatched_confirmation
        expect(response).to have_http_status(:unprocessable_entity)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('Password confirmation does not match')
      end
    end

    context 'when not authenticated' do
      before { sign_out user }
      
      it 'returns unauthorized' do
        put :change_password, params: valid_password_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
