# frozen_string_literal: true

require 'gettext/po_parser'

module Jekyll
  module L10n
    module Model
      class Po

        include Asciidoctor::Logging

        def initialize(path, po_base_dir)
          @path = path
          @po_base_dir = po_base_dir
          dirname = Pathname(path).dirname
          unless dirname.exist?
            raise "Parent directory #{dirname} doesn't exist."
          end

          @po = load_po_object(path)
          @secondary_index = {}
          @po.each do |entry|
            if entry.msgid.class == String
              normalized_message_id = entry.msgid.gsub(".\n", ".  ").gsub("\n", " ")
              @secondary_index[normalized_message_id] = entry
            end
          end
          header = GetText::POEntry.new(:normal)
          header.msgid = ""
          header.msgstr = <<-EOS
Language: ja_JP
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Generator: jekyll-l10n
          EOS

          unless @po.has_key?(header.msgid)
            @po[header.msgid] = header
          end

        end

        attr_reader :path

        def [](key)
          if key.nil? || key.empty?
            return nil
          end
          if @po.has_key? key
            entry = @po[nil, key]
            if entry.fuzzy?
              return nil
            else
              return @po[nil, key].msgstr
            end
          else
            logger.warn("msgid #{key.inspect} is not found in the po file.")
            nil
          end
        end


        def update_entries(sentences)
          entries = []
          sentences.each do |sentence|
            entry = @po[sentence.text]
            if entry.nil?
              entry = @secondary_index[sentence.text]
            end

            if entry.nil?
              entry = GetText::POEntry.new(:normal)
              entry.msgid = sentence.text
            end

            entry.references = [sentence.source]
            entries.append(entry)
          end


          po = GetText::PO.new(@po.order)
          po[""] = @po[""] # copy header
          entries.each do |entry|
            po[entry.msgid] = entry
          end
          @po = po
        end

        def write(file)
          file.write(@po.to_s)
        end

        def inspect
          @path
        end

        private def load_po_object(path)
          po = GetText::PO.new
          if Pathname.new(path).exist?
              parser = GetText::POParser.new
              parser.report_warning = false
              parser.ignore_fuzzy = false
              parser.parse_file(path, po)
          end
          po
        end

      end
    end
  end
end
