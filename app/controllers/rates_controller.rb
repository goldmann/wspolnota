class RatesController < ApplicationController

  def abcd
    redirect_to rates_path
  end

  # GET /rates
  # GET /rates.xml
  def index
    session[:future] = params[:future] ? true : false
    session[:past] = params[:past] ? true : false

    future_rates = []
    now_rates = []
    past_rates = []

    current_date = Time.now.to_date

    Rate::RATES.each do |rate_symbol, r|
      rates = Rate.where("symbol = '#{rate_symbol}'" ).order( 'effective_date_of DESC' )

      current = false

      rates.each do |rate|
        if rate.effective_date_of > current_date
          future_rates << { :rate => rate, :effective_date => :future }
          next
        end

        if rate.effective_date_of <= current_date and !current
          now_rates << { :rate => rate, :effective_date => :now }
          current = true
          next
        end

        if rate.effective_date_of <= current_date and current
          past_rates << { :rate => rate, :effective_date => :past }
          next
        end
      end
    end

    @rates = []

    @rates << future_rates if session[:future] 
    @rates << now_rates
    @rates << past_rates  if session[:past]

    @rates.flatten!

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rates }
    end
  end

  # GET /rates/1
  # GET /rates/1.xml
  def show
    @rate = Rate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rate }
    end
  end

  # GET /rates/new
  # GET /rates/new.xml
  def new
    @rate = Rate.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rate }
    end
  end

  # GET /rates/1/edit
  def edit
    @rate = Rate.find(params[:id])
  end

  # POST /rates
  # POST /rates.xml
  def create
    @rate = Rate.new(params[:rate])

    respond_to do |format|
      if @rate.save
        format.html { redirect_to(@rate, :notice => 'Rate was successfully created.') }
        format.xml  { render :xml => @rate, :status => :created, :location => @rate }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @rate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rates/1
  # PUT /rates/1.xml
  def update
    @rate = Rate.find(params[:id])

    #rate_type = (Rate::RATES.include?( @rate.symbol.to_sym ) ? :general : :management)
    #rate = (rate_type == :general ? Rate::RATES[@rate.symbol.to_sym] : Rate::MANAGEMENT_RATES[@rate.symbol.to_sym])

    respond_to do |format|
      if @rate.update_attributes(params[:rate])
        format.html { redirect_to(@rate, :notice => 'Rate was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /rates/1
  # DELETE /rates/1.xml
  def destroy
    @rate = Rate.find(params[:id])
    @rate.destroy

    respond_to do |format|
      format.html { redirect_to(rates_url) }
      format.xml  { head :ok }
    end
  end
end
