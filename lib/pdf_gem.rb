require "pdf_gem/railtie"
require 'open3'
require 'base64'
require 'renderer'

module PdfGem 
  def self.pdf_from_url(params)
    stdout, stderr, s = Open3.capture3("node #{File.join(File.dirname(__FILE__), 'pdf_generator.js').to_s}", stdin_data: Base64.strict_encode64(params.to_json).to_s)
    if(s.success?) 
      if(params[:destination].present?)
        FileUtils.mv(stdout, params[:destination])
      else
        res = File.open(stdout, 'rb').read
        File.delete(stdout) if File.exist?(stdout)
        return res
      end
    else
      raise stderr.present? ? stderr : "error"
    end 
  end

  def self.pdf_from_string(params)
    tmp = File.join(File.dirname(__FILE__), 'tmp')
    Dir.mkdir(tmp) unless File.exist?(tmp)
    html_file = File.join(tmp, "#{rand(36**40).to_s(36)}.html")   
    File.open(html_file, "w+") do |f|        
      f.write(params[:html])
    end
    params[:url] = "file:#{html_file}"
    result = self.pdf_from_url(params)
    File.delete(html_file) if File.exist?(html_file)
    return result
  end
end
