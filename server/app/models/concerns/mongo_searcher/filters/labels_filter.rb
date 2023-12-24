# frozen_string_literal: true

module MongoSearcher
  module Filters
    module LabelsFilter
      extend ActiveSupport::Concern

      included do
        add_criterion_params :build_labels_filter
      end

      def build_labels_filter
        return unless @original_params[:label_ids]&.size&.positive?

        @search_params[:label_ids.in] = @original_params[:label_ids]
      end
    end
  end
end
