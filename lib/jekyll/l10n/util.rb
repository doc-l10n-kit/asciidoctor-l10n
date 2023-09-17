# frozen_string_literal: true

module Jekyll
  module L10n
    module Util
      def resolve_po_path(adoc_path, po_base_dir)
        Pathname.new(adoc_path + ".po").expand_path(po_base_dir)
      end
      module_function :resolve_po_path
    end
  end
end
