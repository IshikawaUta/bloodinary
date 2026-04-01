module Bloodinary
  class Processor < Parser::AST::Processor
    attr_reader :findings

    def initialize(file, comments = [])
      @file = file
      @findings = []
      @comments = comments
      @rules = [
        Rules::SQLInjectionRule.new,
        Rules::XSSVulnerabilityRule.new,
        Rules::CommandInjectionRule.new,
        Rules::FileAccessRule.new,
        Rules::InsecureRedirectRule.new,
        Rules::WeakCryptoRule.new
      ]
    end

    def ignore?(node)
      return false unless node.loc && node.loc.expression
      line = node.loc.line
      @comments.any? { |c| c.location.line == line && c.text.include?('bloodinary:ignore') }
    end

    # on_send is called for method calls: object.method(args)
    def on_send(node)
      return super if ignore?(node)

      @rules.each do |rule|
        finding = rule.check(node, @file)
        @findings << finding if finding
      end
      super
    end

    # on_xstr is called for backticks: `command`
    def on_xstr(node)
      return super if ignore?(node)

      @rules.each do |rule|
        finding = rule.check(node, @file)
        @findings << finding if finding
      end
      super
    end
  end
end
