# frozen_string_literal: true

module MongoSearcher
  module Queries
    module CrossFieldKeywordsQuery
      extend ActiveSupport::Concern

      def cross_field_keywords_or_query
        return @cross_field_keyword_query_array if @cross_field_keyword_query_array

        return nil if StrUtil.empty?(@original_params[:q_keywords])

        or_arr = []
        @cross_field_keyword_fields.each do |field|
          or_arr << { field => /#{@original_params[:q_keywords].strip.gsub(/[^0-9a-z @.:-]/i, '')}/i }
          if @original_params[:q_keywords].strip.index(/[a-z]/i).nil? && @original_params[:q_keywords].index(/[0-9]/i)
            # Additional matching for phone numbers.
            or_arr << { field => /#{@original_params[:q_keywords].strip.gsub(/[^0-9]/i, '')}/i }
          end
        end
        @cross_field_keyword_query_array = or_arr
        @cross_field_keyword_query_array
      end

      def field_value_search_keywords_query
        return @field_value_query if @field_value_query
        return nil if StrUtil.empty?(@original_params[:q_keywords])

        sanitized_keyword = @original_params[:q_keywords].strip.gsub(/[^0-9a-z @.:-]/i, '')
        @field_value_query = []

        typed_value_types = %w[string integer float datetime boolean list]

        typed_value_types.each do |value_type|
          new_value_condition = {
            'new_value.type_cd' => value_type,
            "new_value.#{value_type}_value" => /#{sanitized_keyword}/i
          }
          old_value_condition = {
            'old_value.type_cd' => value_type,
            "old_value.#{value_type}_value" => /#{sanitized_keyword}/i
          }

          @field_value_query << new_value_condition
          @field_value_query << old_value_condition
        end
        @field_value_query
      end
    end
  end
end
