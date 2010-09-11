require 'prawn'
require 'prawn/table'

module PdfHelper
  def generate_pdf( filename, &block )
    pdf = Prawn::Document.new( :page_size => "A4" )

    pdf.font_size = 10
    pdf.font "#{Rails.root}/app/fonts/DejaVuSerif.ttf"
    pdf.text "Czerwionka-Leszczyny, #{l Time.now.to_date, :format => :long}", :align => :right
    pdf.move_down 20
    pdf.text "Wspólnota mieszkaniowa przy ul. Furgoła 4B w Czerwionce-Leszczynach", :align => :right
    pdf.move_down 50

    block.call( pdf )

    send_data pdf.render, :filename => filename, :type => 'application/pdf', :disposition => 'inline'
  end
end
