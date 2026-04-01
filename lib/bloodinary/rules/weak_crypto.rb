require_relative 'base_rule'

module Bloodinary
  module Rules
    class WeakCryptoRule < BaseRule
      def check(node, file)
        return nil unless node.type == :send
        
        receiver = node.children[0]
        method_name = node.children[1]
        
        # Digest::MD5.hexdigest(data) -> node is hexdigest, receiver is Digest::MD5
        # Digest::MD5 -> node is MD5, receiver is Digest
        if method_name == :hexdigest || method_name == :new || method_name == :digest
          if receiver && receiver.type == :const && [:MD5, :SHA1].include?(receiver.children[1])
            algorithm = receiver.children[1]
            return create_finding(node, file, :MEDIUM, "Algoritma hashing yang lemah (#{algorithm}) terdeteksi. Gunakan SHA256 atau lebih tinggi.")
          end
        end
        nil
      end
    end
  end
end
