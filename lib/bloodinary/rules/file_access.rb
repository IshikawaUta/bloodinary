require_relative 'base_rule'

module Bloodinary
  module Rules
    class FileAccessRule < BaseRule
      TARGET_METHODS = [:read, :open, :readlines, :binread, :write, :delete, :unlink, :stat].freeze

      def check(node, file)
        return nil unless node.type == :send
        
        receiver = node.children[0]
        method_name = node.children[1]
        
        # Mencari pola File.read, Dir.glob, IO.readlines, dll.
        if receiver && receiver.type == :const
          class_name = receiver.children[1]
          
          if [:File, :Dir, :IO].include?(class_name)
            if TARGET_METHODS.include?(method_name) || method_name == :glob
              arg = node.children[2]
              if arg && dynamic?(arg)
                return create_finding(node, file, :HIGH, "Akses file/direktori dengan parameter dinamis terdeteksi. Pastikan untuk mencegah Path Traversal.")
              end
            end
          end
        end
        nil
      end
    end
  end
end
