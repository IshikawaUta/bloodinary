module Bloodinary
  module Rules
    class BaseRule
      def check(node, file)
        # To be implemented by subclasses
      end

      def create_finding(node, file, severity, message)
        {
          file: file,
          line: node.loc.line,
          column: node.loc.column,
          severity: severity,
          message: message,
          code: node.loc.expression.source
        }
      end

      # Helper to check if a node is potentially dynamic/untrusted
      def dynamic?(node)
        return false unless node
        # If it's a string literal, it's safe
        return false if node.type == :str
        # If it's a variable or interpolation, it's dynamic
        true
      end
    end
  end
end
