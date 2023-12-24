# frozen_string_literal: true

module MongoSearcher
  module Filters
    module DateRangeFilter
      extend ActiveSupport::Concern

      included do
        add_criterion_params :build_date_range_filter
      end

      def build_date_range_filter
        @date_range_filter_signal ||= :date_range
        if @date_range_filter_signal.nil? || @mongo_date_field.nil? || @original_params[@date_range_filter_signal].nil?
          return
        end

        min = @original_params[@date_range_filter_signal]['min']
        min_date = EsSearcher::Utils::DateFilterUtils.parse_date_filter(
          min, true, @current_user.time_zone
        )
        @search_params[@mongo_date_field.gte] = min_date if min_date

        max = @original_params[@date_range_filter_signal]['max']
        max_date = EsSearcher::Utils::DateFilterUtils.parse_date_filter(
          max, false, @current_user.time_zone
        )
        return unless max_date

        @search_params[@mongo_date_field.lte] = max_date
      end
    end
  end
end
