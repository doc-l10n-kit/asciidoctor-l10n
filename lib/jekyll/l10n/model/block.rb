# frozen_string_literal: true

require_relative 'abstract_sentence'

module Jekyll
  module L10n
    module Model
      class Block < AbstractSentence

        def text
          @node.source
        end

        def text=(value)
          lines = value.split(/\R/)
          @node.instance_variable_set('@lines', lines)
        end

      end
    end
  end
end
