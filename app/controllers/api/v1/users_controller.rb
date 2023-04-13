module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :set_user, only: [:show, :update, :destroy]

      # GET /users
      def index
        @users = User.order('created_at DESC')
        json_response(@users)
      end

      # GET /users/:id
      def show
        json_response(@user)
      end

      # POST /users
      def create
        @user = User.create!(user_params)
        json_response(@user, :created)
      end

      # PUT /users/:id
      def update
        @user.update!(user_params)
        json_response(@user, :ok)
      end

      def destroy
        @user.destroy
        head :no_content
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        # whitelist params
        params.permit(:name, :username, :email, :website)
      end
    end
  end
end
