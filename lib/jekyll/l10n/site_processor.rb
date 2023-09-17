require 'asciidoctor'
require 'asciidoctor/extensions'
require_relative './document_processor'
require_relative './model/document_title'
require_relative './model/document_synopsis'

module Jekyll
  module L10n
    class SiteProcessor

      include Asciidoctor::Logging

      def initialize(site, config)
        @site = site
        @jekyll_l10n_config = config
        @po_repository = Jekyll::L10n::PoRepository.new(config)
      end

      def update_po_files
        map = {}

        @site.documents.each do |jekyll_document|
          if jekyll_document.data['asciidoc']
            asciidoctor_document = jekyll_document.data['document']
            site_source = asciidoctor_document.attributes['site-source']
            asciidoc = Jekyll::L10n::Model::Asciidoc.new(asciidoctor_document)

            sentences =
              extract_document_sentences(jekyll_document) + asciidoc.extract_sentences

            sentences.each do |sentence|
              sentence_document_path = sentence.source
              po_file_path = Jekyll::L10n::Util.resolve_po_path(sentence_document_path, @jekyll_l10n_config.po_base_dir).to_path
              list = map[po_file_path]
              if list.nil?
                list = []
                map[po_file_path] = list
              end
              list.append(sentence)
            end
          end
        end

        map.each_key do |po_file_path|
          FileUtils.makedirs Pathname(po_file_path).dirname.to_path
          list = map[po_file_path]
          po = @po_repository.load_file(po_file_path)
          if po.nil?
            po = @po_repository.create_file(po_file_path)
          end
          po.update_entries(list)
          @po_repository.save_file(po)
        end
      end

      def extract_document_sentences(jekyll_document)
        [ Jekyll::L10n::Model::DocumentTitle.new(jekyll_document),
          Jekyll::L10n::Model::DocumentSynopsis.new(jekyll_document) ]
          .filter{ |sentence| sentence.text.nil? == false }
      end

    end
  end
end
