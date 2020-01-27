module PdfGem 
  def self.renderer(options, options)
    params = options.except(:prefixes, :template, :disposition, :url, :html, :filename, :formats)
    params[:html] = render_to_string(:action => (template.present? ? template : options.template), formats: options[:formats].present? ? options[:formats] : [:pdf] )
    send_data PdfGem::pdf_from_string(params), type: Mime[:pdf],  disposition: (params[:disposition].present? ? params[:disposition] : 'inline'), :filename => options[:filename]
  end
  
  if Mime::Type.lookup_by_extension(:pdf).nil?
    Mime::Type.register('application/pdf', :pdf)
  end
end
