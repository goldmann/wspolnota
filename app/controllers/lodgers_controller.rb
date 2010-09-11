class LodgersController < ApplicationController
  include ApartmentsHelper
  include PdfHelper
  include RatesHelper
  include ActionView::Helpers::NumberHelper

  # GET /lodgers
  # GET /lodgers.xml
  def index
    @lodgers = Lodger.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lodgers }
    end
  end

  # GET /lodgers/1
  # GET /lodgers/1.xml
  def show
    @lodger = Lodger.find(params[:id])

    @rates = {}
    @sum = 0

    Rate::RATES.each do |rate_symbol, r|
      rate = Rate.where("symbol = '#{rate_symbol}' AND effective_date_of <= '#{Time.now.to_date}'" ).limit(1).order( 'effective_date_of DESC' ).first

      unless rate.nil?
        @rates[rate] = @lodger.person_count unless r[:rate_person_count].nil?
        @rates[rate] = @lodger.apartment.floorage unless r[:rate_floorage].nil?
        @rates[rate] = @lodger.water_consumption unless r[:rate_water_declaration].nil?
        @rates[rate] = 1 unless r[:rate_constant].nil?
      end
    end

    @rates.each { |rate, amount| @sum += rate.value * amount }

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @lodger }
      format.pdf  do
        generate_pdf( "#{@lodger.apartment.number}_#{@lodger.first_name}_#{@lodger.last_name}_#{Time.now.to_date}.pdf" ) do |pdf|
          pdf.font "#{Rails.root}/app/fonts/DejaVuSerif-Bold.ttf" do
            pdf.text "Miesięczne zaliczki na pokrycie kosztów utrzymania lokalu nr #{@lodger.apartment.number}", :size => 12, :align => :center
          end

          pdf.move_down 50

          pdf.table([
                  ["Numer lokalu", "#{@lodger.apartment.number}"],
                  ["Właściciel lokalu", "#{@lodger.first_name} #{@lodger.last_name}"],
                  ["Powierzchnia lokalu", "#{@lodger.apartment.floorage} m²"],
                  ["Liczba osób", "#{@lodger.person_count}"],
                  ["Zadeklarowane zużycie wody", "#{@lodger.water_consumption} m³"]
          ], :font_size => 10, :border_style => :underline_header, :align => :left, :padding => 2, :column_widths => { 0 => 180} )

          data = []
          i = 0

          @rates.each do |rate, amount|
            data << [ i+= 1, Rate::RATES[rate.symbol.to_sym][:name], number_to_currency(rate.value), amount, rate_unit( rate ), number_to_currency(rate.value * amount) ]
          end

          pdf.move_down 50

          pdf.table(data, :headers => ["L.p.", "Składnik", "Cena jendnostkowa", "Ilość", "Jednostka", "Wartość"], :font_size => 10, :border_style => :grid, :border_width => 0.2, :align => :left, :padding => 2, :width => pdf.bounds.width)

          pdf.move_down 10

          pdf.text "Suma: #{number_to_currency( @sum ) }", :size => 12, :align => :right
        end
      end
    end
  end

# GET /lodgers/new
# GET /lodgers/new.xml
  def new
    @lodger = Lodger.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @lodger }
    end
  end

# GET /lodgers/1/edit
  def edit
    @lodger = Lodger.find(params[:id])
  end

# POST /lodgers
# POST /lodgers.xml
  def create
    @lodger = Lodger.new(params[:lodger])

    respond_to do |format|
      if @lodger.save
        format.html { redirect_to(@lodger, :notice => 'Lodger was successfully created.') }
        format.xml  { render :xml => @lodger, :status => :created, :location => @lodger }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @lodger.errors, :status => :unprocessable_entity }
      end
    end
  end

# PUT /lodgers/1
# PUT /lodgers/1.xml
  def update
    @lodger = Lodger.find(params[:id])

    respond_to do |format|
      if @lodger.update_attributes(params[:lodger])
        format.html { redirect_to(@lodger, :notice => 'Lodger was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @lodger.errors, :status => :unprocessable_entity }
      end
    end
  end

# DELETE /lodgers/1
# DELETE /lodgers/1.xml
  def destroy
    @lodger = Lodger.find(params[:id])
    @lodger.destroy

    respond_to do |format|
      format.html { redirect_to(lodgers_url) }
      format.xml  { head :ok }
    end
  end

end
