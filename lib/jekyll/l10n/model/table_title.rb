# frozen_string_literal: true

require_relative 'abstract_sentence'

module Jekyll
  module L10n
    module Model
      class TableTitle < AbstractSentence

        def text
          @node.instance_variable_get('@title')
        end

        def text=(value)
          @node.title = value
        end

      end
    end
  end
end
