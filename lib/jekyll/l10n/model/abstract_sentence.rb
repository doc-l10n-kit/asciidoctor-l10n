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
          file = @node.file
          parent = @node.parent
          while file == nil && parent != nil
            file = parent.file
            parent = parent.parent
          end
          if file.nil?
            file = @node.document.attributes['docfile']
          end
          site_source = @node.document.attributes['site-source']
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
