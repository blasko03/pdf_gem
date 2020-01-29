require 'test_helper'
require 'open-uri'
class PdfGem::Test < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, PdfGem
  end

  test "pdf_generation_from_url" do
    input = File.join(File.dirname(__FILE__), 'test_files', 'input.html')   
    dest = File.join(File.dirname(__FILE__), 'test_files', 'results', 'output.pdf')   
    File.delete(dest) if File.exist?(dest)
    PdfGem::pdf_from_url({url: "file:#{input}", destination: dest})
    assert File.exist?(dest)
    assert File.size(dest)>0
  end

  test "pdf_generation_from_string" do
    input = File.join(File.dirname(__FILE__), 'test_files', 'input.html')   
    dest = File.join(File.dirname(__FILE__), 'test_files', 'results', 'output_from_string.pdf')   
    File.delete(dest) if File.exist?(dest)
    PdfGem::pdf_from_string({html: File.read(input), destination: dest})
    assert File.exist?(dest)
    assert File.size(dest)>0
  end

  def save_to_file(destination, data)   
    File.open(destination, "wb") do |f|
      f.write(data)
    end
  end
  
  test "is_saving_file_from_binary" do
    bin = File.join(File.dirname(__FILE__), 'test_files', 'results', 'bin.pdf')   
    save_to_file(bin, PdfGem::pdf_from_string({html: URI.open('https://en.wikipedia.org/wiki/Car').read})) 
  end
end
