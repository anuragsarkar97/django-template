# frozen_string_literal: true

module MongoSearcher
  module Filters
    module PriorityFilter
      extend ActiveSupport::Concern
      included do
        add_criterion_params :build_priority_filter
        def build_priority_filter
          priority_cds = @original_params[:priorities].to_a
          return if priority_cds.blank?

          @search_params[:priority_cd.in] = priority_cds
        end
      end
    end
  end
end
