# frozen_string_literal: true

module MongoSearcher
  module Filters
    module IdsFilter
      extend ActiveSupport::Concern

      included do
        add_criterion_params :build_ids_filter
      end

      def build_ids_filter
        return unless @original_params[:ids]

        @search_params[:id.in] = @original_params[:ids]
      end
    end
  end
end
