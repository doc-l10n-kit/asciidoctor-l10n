# frozen_string_literal: true

require_relative 'sentence'

module Jekyll
  module L10n
    module Model
      class AbstractSentence < Sentence

        def initialize(node)
          @node = node
        end

        def source
          file = @node.document.options[:attributes]['docfile']
          site_source = @node.document.options[:attributes]['site-source']

          Pathname(file).relative_path_from(site_source).to_path
        end

        def lineno
          @node.lineno
        end

        def text
          @node.source
        end

        def text=(value)
          @node.source = value
        end

        attr_reader :node

      end
    end
  end
end
