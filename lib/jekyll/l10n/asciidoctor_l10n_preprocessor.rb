require 'asciidoctor'
require 'asciidoctor/extensions'

module Jekyll
  module L10n
    class AsciidoctorL10nPreprocessor < ::Asciidoctor::Extensions::Preprocessor

      include Asciidoctor::Logging

      def process(document, reader)
        document.sourcemap = true
        nil
      end

    end
  end
end
