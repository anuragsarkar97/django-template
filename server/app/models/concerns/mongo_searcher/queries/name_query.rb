# frozen_string_literal: true

module MongoSearcher
  module Queries
    module NameQuery
      extend ActiveSupport::Concern

      included do
        add_criterion_params :build_name_query
      end

      def build_name_query
        q_name = @original_params[:q_name].to_s.gsub(/[^0-9a-z ]/i, ' ').strip
        return if StrUtil.empty?(q_name)

        components = q_name.split(' ')
        regex_str = components.join('.*')
        # @original_params[:q_name].gsub(/[^0-9a-z ]/i, '')
        @search_params[:name] = /#{regex_str}/i
      end
    end
  end
end
