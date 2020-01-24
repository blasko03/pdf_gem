require "pdf_gem/railtie"
require 'open3'
require 'base64'
require 'renderer'

module PdfGem 
  def self.pdf_from_url(params)
    
    stdout, stderr = Open3.capture3("node #{File.join(File.dirname(__FILE__), 'pdf_generator.js').to_s} #{Base64.strict_encode64(params.to_json).to_s}")
   
    if(stdout.present? and stderr.empty?)
      if(params[:destination].present?)
        self.save_to_file(params[:destination], stdout)
      else
        return Base64.decode64(stdout)
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

  def self.save_to_file(destination, data)   
    File.open(destination, "wb") do |f|
      f.write(Base64.decode64(data))
    end
  end
end
