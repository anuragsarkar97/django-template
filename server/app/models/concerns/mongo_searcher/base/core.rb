# frozen_string_literal: true

module MongoSearcher
  module Base
    module Core
      extend ActiveSupport::Concern
      include ActiveData::Model

      included do
        class_attribute :criterion_params_processors
        class_attribute :sort_function
        self.criterion_params_processors = []
      end

      def processed_search_params
        self.class.criterion_params_processors.each do |piece|
          send(piece)
        end
        @search_params
      end

      def hits(only_fields = [], includes = [])
        return @models if @models

        @page = @page.to_i
        @per_page = @per_page.to_i

        return criteria.only(only_fields).to_a if only_fields.size.positive?

        hits_criteria = criteria
        hits_criteria = hits_criteria.criteria.includes(includes) if includes.size.positive?

        @models = hits_criteria.to_a
        @models
      end

      def hit_ids
        hits([:id]).map(&:id)
      end

      def pagination
        total_pages = if per_page.zero?
                        1
                      else
                        (total_entries - 1) / per_page + 1
                      end

        {
          page: @page,
          per_page: @per_page,
          total_entries: total_entries,
          total_pages: total_pages
        }
      end

      def total_entries
        @total_entries ||= criteria.count
      end

      def per_page
        @per_page.to_i
      end

      def total_pages
        @total_pages ||= (total_entries - 1) / per_page + 1
      end

      def breadcrumbs
        ::EsSearcher::Breadcrumbs.generate(@original_params, self.class)
      end

      module ClassMethods
        protected

        def add_criterion_params(criterion_piece)
          criterion_params_processors << criterion_piece
        end
      end
    end
  end
end
