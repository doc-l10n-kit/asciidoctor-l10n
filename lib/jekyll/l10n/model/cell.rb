# frozen_string_literal: true

require_relative 'abstract_sentence'

module Jekyll
  module L10n
    module Model
      class Cell < AbstractSentence

        def text
          @node.instance_variable_get('@text')
        end

        def text=(value)
          @node.instance_variable_set('@text', value)
        end
        
      end
    end
  end
end
