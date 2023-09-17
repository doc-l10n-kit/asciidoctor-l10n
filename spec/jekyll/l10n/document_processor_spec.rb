require 'asciidoctor'
require 'asciidoctor/document'
require_relative '../../../lib/jekyll/l10n/model/asciidoc'
require_relative '../../../lib/jekyll/l10n/document_processor'
require_relative '../../../spec/test/test_config.rb'

describe Jekyll::L10n::DocumentProcessor do

  it 'can update_po_file' do
    spec_dir = Pathname(File.dirname(File.dirname(File.dirname(__FILE__))))
    file_path = spec_dir.join('sample/adoc/sample.adoc')

    attributes = {"skip-front-matter" => true }
    document = Asciidoctor.load_file file_path, safe: :safe, sourcemap: true, attributes: attributes
    document.attributes['site-source'] = spec_dir.join('sample/adoc')
    config = TestConfig.new
    document_processor = Jekyll::L10n::DocumentProcessor.new(document, config)
    document_processor.update_po_file
  end

end
