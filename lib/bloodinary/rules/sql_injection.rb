require_relative 'base_rule'

module Bloodinary
  module Rules
    class SQLInjectionRule < BaseRule
      TARGET_METHODS = [:where, :find_by, :execute, :query].freeze

      def check(node, file)
        method_name = node.children[1]
        return nil unless TARGET_METHODS.include?(method_name)

        # Check the first argument
        arg = node.children[2]
        return nil unless arg

        if dynamic_query?(arg)
          return create_finding(node, file, :HIGH, "Potensi SQL Injection terdeteksi pada pemanggilan metode '#{method_name}'.")
        end
        nil
      end

      private

      def dynamic_query?(node)
        # :dstr is a string with interpolation
        # :lvar is a local variable
        # :send is another method call
        [:dstr, :lvar, :send, :ivar].include?(node.type)
      end
    end
  end
end
