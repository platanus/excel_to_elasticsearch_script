require "roo"
module Roo
  class Excelx
    class SheetDoc
      # Disable hyperlinks
      # it makes ROO parse the complete XML tree into memory
      def hyperlinks(_relationships)
        @hyperlinks ||= {}
      end
    end
  end
end
