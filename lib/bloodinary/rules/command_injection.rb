require_relative 'base_rule'

module Bloodinary
  module Rules
    class CommandInjectionRule < BaseRule
      TARGET_METHODS = [:system, :exec, :spawn].freeze

      def check(node, file)
        # Handle method calls (system, exec, spawn)
        if node.type == :send
          method_name = node.children[1]
          if TARGET_METHODS.include?(method_name)
            arg = node.children[2]
            if arg && dynamic_command?(arg)
              return create_finding(node, file, :CRITICAL, "Pemanggilan perintah sistem '#{method_name}' dengan data dinamis. Risiko Command Injection!")
            end
          end
        end

        # Handle backticks (xstr)
        if node.type == :xstr
          if node.children.any? { |c| c.type == :begin } # Interpolation inside backticks
            return create_finding(node, file, :CRITICAL, "Backticks dengan interpolasi variabel terdeteksi. Risiko Command Injection!")
          end
        end
        nil
      end

      private

      def dynamic_command?(node)
        # Check if argument is dynamic
        [:dstr, :lvar, :ivar, :send].include?(node.type)
      end
    end
  end
end
