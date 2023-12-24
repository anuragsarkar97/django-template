# frozen_string_literal: true

module MongoSearcher
  module Base
    module DefaultSort
      extend ActiveSupport::Concern

      protected

      def default_sort_hash(use_default_as_secondary_criteria = false)
        @sort_hash = {}
        @sort_hash[@default_sort_field] = @default_sort_ascending_indicator if @default_sort_field

        if @original_params[:sort_by_field]
          sort_ascending_indicator = @original_params[:sort_ascending] == 'true' || @original_params[:sort_ascending] == true ? 1 : -1

          @original_params[:sort_by_field] = @original_params[:sort_by_field].underscore
          @sort_hash = if use_default_as_secondary_criteria
                         { @original_params[:sort_by_field] => sort_ascending_indicator,
                           @default_sort_field => sort_ascending_indicator }
                       else
                         { @original_params[:sort_by_field] => sort_ascending_indicator }
                       end
        end
        @sort_hash
      end
    end
  end
end
