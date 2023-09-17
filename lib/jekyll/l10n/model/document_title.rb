# frozen_string_literal: true

require_relative 'abstract_sentence'

module Jekyll
  module L10n
    module Model
      class DocumentTitle < Sentence

        def initialize(jekyll_document)
          @jekyll_document = jekyll_document
        end

        def source
          file = @jekyll_document.data['document'].attributes['docfile']
          site_source = @jekyll_document.data['document'].attributes['site-source']
          Pathname(file).relative_path_from(site_source).to_path
        end

        def lineno
          1 #TODO
        end

        def text
          @jekyll_document.data['title']
        end

        def text=(value)
          @jekyll_document.data['title'] = value
        end

      end
    end
  end
end
