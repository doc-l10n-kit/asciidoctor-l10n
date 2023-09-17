require 'asciidoctor'
require 'asciidoctor/document'
require_relative '../../../../lib/jekyll/l10n/model/asciidoc'

describe Jekyll::L10n::Model::Asciidoc do

  it 'can extract sentences' do
    spec_dir = Pathname(File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))))
    file_path = spec_dir.join('sample/adoc/sample.adoc')

    attributes = {"skip-front-matter" => true }
    document = Asciidoctor.load_file file_path, safe: :safe, sourcemap: true, attributes: attributes
    asciidoc = Jekyll::L10n::Model::Asciidoc.new(document)
    sentences = asciidoc.extract_sentences
    sentences.size
  end

end
