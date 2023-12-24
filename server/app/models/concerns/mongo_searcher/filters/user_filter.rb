# frozen_string_literal: true

module MongoSearcher
  module Filters
    module UserFilter
      extend ActiveSupport::Concern

      included do
        add_criterion_params :build_user_filter
      end

      def build_user_filter
        user_id_field = @user_id_field || :user_id

        @search_params[:user_id.ne] = @original_params[:not_user_id] if @original_params[:not_user_id]

        if @original_params[:user_id] == 'current'
          @search_params[user_id_field] = @original_params[:user_id]
        elsif @original_params[:user_id]
          @search_params[user_id_field] = @original_params[:user_id]
        elsif @original_params[:user_ids]
          if @original_params[:user_ids].include? 'any' # Does not include nil/unassigned user field
            @search_params[user_id_field.in] = @current_user.team.user_ids
          else
            unassigned_to_add = if @original_params[:user_ids].include? 'unassigned'
                                  [nil]
                                else
                                  []
                                end
            @search_params[user_id_field.in] =
              ::UserFilterUtil.process_user_ids(@original_params[:user_ids], @current_user) + unassigned_to_add
          end
        elsif !@disable_default_apply_user_filter
          # For Opportunity, some owner_id might be nil
          @search_params[user_id_field.in] = @current_user.team.user_ids
        end
      end
    end
  end
end
