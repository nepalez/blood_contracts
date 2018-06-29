module BloodContracts
  module StringCamelize
    refine String do
      # See gem Facets String#camelcase
      #
      # Converts a string to camelcase. This method leaves the first character
      # as given. This allows other methods to be used first, such as #uppercase
      # and #lowercase.
      #
      #   "camel_case".camelcase          #=> "camelCase"
      #   "Camel_case".camelcase          #=> "CamelCase"
      #
      # Custom +separators+ can be used to specify the patterns used to determine
      # where capitalization should occur. By default these are underscores (`_`)
      # and space characters (`\s`).
      #
      #   "camel/case".camelcase('/')     #=> "camelCase"
      #
      # If the first separator is a symbol, either `:lower` or `:upper`, then
      # the first characters of the string will be downcased or upcased respectively.
      #
      #   "camel_case".camelcase(:upper)  #=> "CamelCase"
      #
      # Note that this implementation is different from ActiveSupport's.
      # If that is what you are looking for you may want {#modulize}.
      #
      def camelcase(*separators)
        case separators.first
        when Symbol, TrueClass, FalseClass, NilClass
          first_letter = separators.shift
        end

        separators = ['_', '\s'] if separators.empty?

        str = self.dup

        separators.each do |s|
          str = str.gsub(/(?:#{s}+)([a-z])/){ $1.upcase }
        end

        case first_letter
        when :upper, true
          str = str.gsub(/(\A|\s)([a-z])/){ $1 + $2.upcase }
        when :lower, false
          str = str.gsub(/(\A|\s)([A-Z])/){ $1 + $2.downcase }
        end

        str
      end
    end
  end
end
