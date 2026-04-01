module Bloodinary
  class Scanner
    def initialize(options = {})
      @options = options
      @findings = []
    end

    TEMPLATE_EXTENSIONS = ['.erb', '.html', '.rhtml', '.haml', '.slim'].freeze

    def scan(path, ignore_paths = [])
      @start_time = Time.now
      @file_count = 0
      @findings = []

      Find.find(path) do |f|
        # Ignore logic (skip vendor, spec, etc if specified)
        if ignore_paths.any? { |ignore| f.include?(ignore) }
          Find.prune if File.directory?(f)
          next
        end

        next if File.directory?(f)
        
        ext = File.extname(f).downcase
        if ext == '.rb'
          @file_count += 1
          @findings.concat(scan_file(f))
        elsif TEMPLATE_EXTENSIONS.include?(ext)
          @file_count += 1
          @findings.concat(scan_template_file(f))
        end
      end
      
      @end_time = Time.now
      {
        findings: @findings,
        metadata: {
          file_count: @file_count,
          duration: @end_time - @start_time,
          start_time: @start_time,
          end_time: @end_time
        }
      }
    end

    def scan_file(file)
      begin
        source = File.read(file)
        parse_and_process(source, file)
      rescue StandardError => e
        puts "Error scanning #{file}: #{e.message}"
        []
      end
    end

    def scan_template_file(file)
      begin
        content = File.read(file)
        ruby_code = extract_ruby_from_erb(content)
        parse_and_process(ruby_code, file)
      rescue StandardError
        # Fail silently for template noise
        []
      end
    end

    private

    def parse_and_process(source, file)
      parser = Parser::CurrentRuby.new
      buffer = Parser::Source::Buffer.new(file)
      buffer.source = source
      ast, comments = parser.parse_with_comments(buffer)
      
      return [] unless ast
      
      processor = Processor.new(file, comments)
      processor.process(ast)
      processor.findings
    end

    def extract_ruby_from_erb(content)
      output = ""
      last_pos = 0
      
      content.scan(/<%([=-]?)\s*(.*?)\s*-?%>/m) do |type, code|
        start_pos = Regexp.last_match.begin(0)
        end_pos = Regexp.last_match.end(0)
        
        # Replace HTML with spaces to preserve line/column info
        skipped = content[last_pos...start_pos]
        output << skipped.gsub(/[^\n]/, ' ')
        
        # Output tags are wrapped in a helper
        if type == '='
          output << "_bloodinary_output(#{code})"
        else
          output << code
        end
        
        last_pos = end_pos
      end
      
      # Add the rest of the file as spaces
      if last_pos < content.length
        output << content[last_pos..-1].gsub(/[^\n]/, ' ')
      end
      
      output
    end
  end
end
