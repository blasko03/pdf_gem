module PdfGem 
  ActionController::Renderers.add :pdf do |template, options|
    send_data PdfGem::pdf_from_string({html: render_to_string(template)}), type: Mime[:pdf],  disposition: "attachment; filename=#{options[:filename]}"
  end

  if Mime::Type.lookup_by_extension(:pdf).nil?
    Mime::Type.register('application/pdf', :pdf)
  end
end
