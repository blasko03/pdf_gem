module PdfGem 
  ActionController::Renderers.add :pdf2 do |template, options|
    params = options.except(:prefixes, :template)
    params[:html] = render_to_string(template.present? ? template : options.template)
    send_data PdfGem::pdf_from_string(params), type: Mime[:pdf],  disposition: "attachment; filename=#{options[:filename]}"
  end

  if Mime::Type.lookup_by_extension(:pdf).nil?
    Mime::Type.register('application/pdf', :pdf)
  end
end
