require 'asciidoctor'
require 'asciidoctor/document'
require_relative '../../../../lib/jekyll/l10n/model/po'
require_relative '../../../../lib/jekyll/l10n/model/asciidoc'
require_relative '../../../../lib/jekyll/l10n/po_repository'

describe Jekyll::L10n::Model::Po do

  it 'can update entries' do
    @po_repository = Jekyll::L10n::PoRepository.new

    spec_dir = Pathname(File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))))
    po_file_path = spec_dir.join('sample/po/sample.adoc.po')
    adoc_file_path = spec_dir.join('sample/adoc/sample.adoc')

    attributes = {"skip-front-matter" => true }
    document = Asciidoctor.load_file adoc_file_path.to_path, safe: :safe, sourcemap: true, attributes: attributes
    asciidoc = Jekyll::L10n::Model::Asciidoc.new(document)
    sentences = asciidoc.extract_sentences
    po = @po_repository.load_file(po_file_path.to_path)
    po.update_entries(sentences)
    

    po
  end

  it 'can handle a fuzzy entry' do
    @po_repository = Jekyll::L10n::PoRepository.new

    spec_dir = Pathname(File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))))
    po_file_path = spec_dir.join('sample/po/fuzzy.adoc.po')

    po = @po_repository.load_file(po_file_path.to_path)
    po
  end

end