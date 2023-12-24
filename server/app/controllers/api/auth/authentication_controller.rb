# frozen_string_literal: true

# user login APIs
module Api
  module Auth
    class AuthenticationController < ApplicationController

      def get_user
        token = params[:token]
        user = User.user_from_token(token)
        render json: { user: user }
      end

      def sign_in
        email = params[:email]
        password = params[:password]
        slug = params[:slug]

        team = Team.where(slug: slug).first
        if team.nil?
          render json: { error: 'Team not found' }, status: :not_found
          return
        end
        user = User.find(team_id: team.id, email: email).first
        if user.nil?
          render json: { error: 'User not found' }, status: :not_found
          return
        end
        if user.authenticate(password)
          render json: { token: user.token }
        else
          render json: { error: 'Invalid password' }, status: :unauthorized
        end
      end

      def sign_up
        email = params[:email]
        password = params[:password]
        slug = params[:slug]

        team = Team.where(slug: slug).first
        unless team.nil?
          render json: { error: 'Slug already exists' }, status: :bad_request
          return
        end
        user = User.where(email: email).first
        if user
          render json: { error: 'Email already exists' }, status: :bad_request
          return
        end
        team = Team.new(slug: slug)
        team.save!
        user = User.new(name: email, email: email, password: password, team_id: team.id)
        user.save!
        render json: { message: 'User created', token: user.token }, status: :created
      end

      def sign_out
        token = params[:token]
        Rails.cache.delete("user_token_#{token}")
        render json: { message: 'User signed out' }
      end

      def verify

      end

      def forgot_password

      end

      def reset_password

      end

      private

    end
  end
end

