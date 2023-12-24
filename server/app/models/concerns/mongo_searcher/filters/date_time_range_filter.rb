# frozen_string_literal: true

module MongoSearcher
  module Filters
    module DateTimeRangeFilter
      extend ActiveSupport::Concern

      included do
        add_criterion_params :build_date_time_range_filter
      end

      def build_date_time_range_filter
        @date_time_range_signal = :date_time_range
        if @date_time_range_signal.nil? || @mongo_date_field.nil? || @original_params[@date_time_range_signal].nil?
          return
        end

        min = @original_params.dig(@date_time_range_signal, :min)
        @search_params[@mongo_date_field.gte] = min if min

        max = @original_params.dig(@date_time_range_signal, :max)
        @search_params[@mongo_date_field.lte] = max if max
      end
    end
  end
end
