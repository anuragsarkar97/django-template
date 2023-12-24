# frozen_string_literal: true

module MongoSearcher
  module Filters
    module StarredFilter
      extend ActiveSupport::Concern

      included do
        add_criterion_params :build_starred_by_current_user_filter
      end

      def build_starred_by_current_user_filter
        return unless @original_params[:starred_by_current_user]

        @search_params[:starred_by_user_ids] = @current_user.id
      end
    end
  end
end
