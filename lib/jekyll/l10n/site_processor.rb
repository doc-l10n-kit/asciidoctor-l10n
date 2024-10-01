require 'asciidoctor'
require 'asciidoctor/extensions'
require_relative './document_processor'
require_relative './model/document_title'
require_relative './model/document_synopsis'
require_relative './model/page_title'
require_relative './model/page_intro'

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
          begin
            if jekyll_document.data['asciidoc']
              asciidoctor_document = jekyll_document.data['document']
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
          rescue => e
            logger.error("Failed to process #{jekyll_document.data['document'].attributes['docfile']}")
            raise e
          end
        end

        @site.pages.each do |jekyll_page|
          begin
            if jekyll_page.data['asciidoc']
              asciidoctor_document = Asciidoctor.load_file(jekyll_page.path, attributes: {'site-source' => @site.source} )
              asciidoc = Jekyll::L10n::Model::Asciidoc.new(asciidoctor_document)

              sentences =
                extract_page_sentences(jekyll_page) + asciidoc.extract_sentences

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
          rescue => e
            logger.error("Failed to process #{jekyll_page.path}")
            raise e
          end
        end

        map.each_key do |po_file_path|
          begin
            FileUtils.makedirs Pathname(po_file_path).dirname.to_path
            list = map[po_file_path]
            po = @po_repository.load_file(po_file_path)
            if po.nil?
              po = @po_repository.create_file(po_file_path)
            end
            po.update_entries(list)
            @po_repository.save_file(po)
          rescue => e
            logger.error("Failed to process #{po_file_path}")
            raise e
          end
        end
      end

      def extract_document_sentences(jekyll_document)
        [ Jekyll::L10n::Model::DocumentTitle.new(jekyll_document),
          Jekyll::L10n::Model::DocumentSynopsis.new(jekyll_document) ]
          .filter{ |sentence| sentence.text.nil? == false }
      end

      def extract_page_sentences(jekyll_page)
        [ Jekyll::L10n::Model::PageTitle.new(jekyll_page),
          Jekyll::L10n::Model::PageIntro.new(jekyll_page) ]
          .filter{ |sentence| sentence.text.nil? == false }
      end

    end
  end
end
