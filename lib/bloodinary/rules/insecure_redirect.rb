require_relative 'base_rule'

module Bloodinary
  module Rules
    class InsecureRedirectRule < BaseRule
      def check(node, file)
        return nil unless node.type == :send
        
        method_name = node.children[1]
        
        # redirect(params[:url]) atau redirect_to(url)
        if [:redirect, :redirect_to].include?(method_name)
          arg = node.children[2]
          
          if arg && dynamic?(arg)
            return create_finding(node, file, :MEDIUM, "Pengalihan (redirect) menggunakan data dinamis tanpa validasi. Risiko Open Redirect ke situs berbahaya.")
          end
        end
        nil
      end
    end
  end
end
