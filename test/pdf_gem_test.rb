require 'test_helper'

class PdfGem::Test < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, PdfGem
  end

  test "pdf_generation_from_url" do
    input = File.join(File.dirname(__FILE__), 'test_files', 'input.html')   
    dest = File.join(File.dirname(__FILE__), 'test_files', 'output.pdf')   
    File.delete(dest) if File.exist?(dest)
    PdfGem::pdf_from_url({url: "file:#{input}", destination: dest})
    assert File.exist?(dest)
    assert File.size(dest)>0
  end

  test "pdf_generation_from_string" do
    input = File.join(File.dirname(__FILE__), 'test_files', 'input.html')   
    dest = File.join(File.dirname(__FILE__), 'test_files', 'output_from_string.pdf')   
    File.delete(dest) if File.exist?(dest)
    PdfGem::pdf_from_string({html: File.read(input), destination: dest})
    assert File.exist?(dest)
    assert File.size(dest)>0
  end

  def save_to_file(destination, data)   
    File.open(destination, "wb") do |f|
      f.write(Base64.decode64(data))
    end
  end
  
  test "is_saving_file" do
    input = File.join(File.dirname(__FILE__), 'test_files', 'test.pdf')
    copy = File.join(File.dirname(__FILE__), 'test_files', 'copy.pdf')
    File.delete(copy) if File.exist?(copy)
    PdfGem::save_to_file(copy, Base64.encode64(IO.binread(input)))
    assert File.exist?(copy)
    assert FileUtils.compare_file(input, copy)  
  end
end
