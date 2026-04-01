module Bloodinary
  class Reporter
    def self.report(result, format = :text)
      if format == :json
        puts JSON.pretty_generate(result)
      else
        print_text_report(result)
      end
    end

    def self.print_text_report(result)
      findings = result[:findings]
      metadata = result[:metadata]

      # Header
      header = " BLOODINARY SECURITY SCANNER "
      puts "\n" + Rainbow(" " * 80).bg(:red)
      puts Rainbow(header.center(80)).black.bg(:red).bold
      puts Rainbow(" " * 80).bg(:red)
      puts "\n"

      if findings.empty?
        puts Rainbow("  PASSED: Tidak ditemukan kerentanan keamanan yang mencolok. ✨").green.bold
      else
        puts Rainbow("  TERDETEKSI #{findings.size} KERENTANAN:").red.bold
        puts "\n"
        
        findings.each_with_index do |f, i|
          color = severity_color(f[:severity])
          severity_text = " #{f[:severity]} "
          print "  " + Rainbow(severity_text).black.bg(color).bold
          print " " + Rainbow(f[:message]).bold
          puts "\n"
          puts Rainbow("  File:  ").bright + Rainbow("#{f[:file]}:#{f[:line]}").underline
          puts Rainbow("  Kode:  ").bright + Rainbow("> #{f[:code].strip}").italic
          puts "  " + Rainbow("-" * 76).faint
        end
      end
      
      print_summary(result)
      
      # Footer
      puts "\n" + Rainbow(" Scan selesai pada #{metadata[:end_time].strftime('%H:%M:%S')} (Durasi: #{metadata[:duration].round(2)}s) ").faint.center(80)
      puts "\n"
    end

    def self.print_summary(result)
      findings = result[:findings]
      metadata = result[:metadata]
      
      counts = Hash.new(0)
      findings.each { |f| counts[f[:severity]] += 1 }

      puts "\n" + Rainbow(" RINGKASAN TEMUAN ").black.bg(:white).bold
      puts Rainbow(" ┌────────────────────┬──────────┐ ").faint
      puts Rainbow(" │ Tingkat Keparahan  │ Jumlah   │ ").faint
      puts Rainbow(" ├────────────────────┼──────────┤ ").faint
      [:CRITICAL, :HIGH, :MEDIUM].each do |sev|
        color = severity_color(sev)
        label = sev.to_s.ljust(18)
        count = counts[sev].to_s.rjust(8)
        puts Rainbow(" │ ").faint + Rainbow(label).color(color) + Rainbow(" │ ").faint + Rainbow(count).bold + Rainbow(" │ ").faint
      end
      puts Rainbow(" ├────────────────────┼──────────┤ ").faint
      puts Rainbow(" │ Total File Scan    │ ").faint + metadata[:file_count].to_s.rjust(8) + Rainbow(" │ ").faint
      puts Rainbow(" └────────────────────┴──────────┘ ").faint
    end

    def self.severity_color(severity)
      case severity
      when :CRITICAL then :magenta
      when :HIGH then :red
      when :MEDIUM then :yellow
      else :blue
      end
    end
  end
end
