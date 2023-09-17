require 'asciidoctor'
require 'asciidoctor/document'
require 'asciidoctor/extensions'
require_relative 'jekyll/l10n/asciidoctor_l10n_preprocessor'
require_relative 'jekyll/l10n/asciidoctor_l10n_tree_processor'
require_relative 'jekyll/l10n/site_processor'
require_relative 'jekyll/l10n/l10n_config'

module Jekyll
  module L10n

    Jekyll::Hooks.register :site, :after_init do |site|

      config = L10nConfig.new(site.config)

      Asciidoctor::Extensions.register do
        preprocessor Jekyll::L10n::AsciidoctorL10nPreprocessor
        tree_processor(Jekyll::L10n::AsciidoctorL10nTreeProcessor, {:jekyll_l10n_config => config})
      end
    end

    Jekyll::Hooks.register :site, :post_render do |site|
      config = L10nConfig.new(site.config)
      if config.mode == 'update_po'
        Jekyll::L10n::SiteProcessor.new(site, config).update_po_files
      end
    end

    Jekyll::Hooks.register :documents, :pre_render do |document|
      config = L10nConfig.new(document.site.config)
      if config.mode == 'translate'
        Jekyll::L10n::DocumentProcessor.new(document, config).translate
      end
    end
  end
end
