# frozen_string_literal: true

module MongoSearcher
  module Filters
    module ArchivedFilter
      extend ActiveSupport::Concern

      included do
        add_criterion_params :build_archived_filter
      end

      def build_archived_filter
        if @original_params[:archived] == 'yes'
          @search_params[:archived] = true
        else
          @search_params[:archived.ne] = true
        end
      end
    end
  end
end
