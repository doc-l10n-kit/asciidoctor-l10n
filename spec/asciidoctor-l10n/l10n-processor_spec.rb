require_relative '../../lib/jekyll-l10n'

describe AsciidoctorL10n::AsciidoctorL10nProcessor do

  it 'can convert adoc file' do
    spec_dir = Pathname(File.dirname(File.dirname(__FILE__)))
    file_path = spec_dir.join('sample/adoc/sample.adoc')
    attributes = {
      'source_adoc_base_dir' => spec_dir.join("sample/adoc").to_path,
      'po_base_dir' => spec_dir.join("sample/po").to_path,
      'skip-front-matter' => true
    }
    converted = Asciidoctor.convert_file file_path, {safe: "unsafe", attributes: attributes}
    expect(1).to eq 1
  end

end
