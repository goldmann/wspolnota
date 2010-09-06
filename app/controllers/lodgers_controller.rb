class LodgersController < ApplicationController
  include ApartmentsHelper

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

    Rate::RATES.each do |rate_symbol, r|
      rate = Rate.where("symbol = '#{rate_symbol}' AND effective_date_of <= '#{Time.now.to_date}'" ).limit(1).order( 'effective_date_of DESC' ).first

      unless rate.nil?
        @rates[rate] = @lodger.person_count unless r[:rate_person_count].nil?
        @rates[rate] = @lodger.apartment.floorage unless r[:rate_floorage].nil?
        @rates[rate] = @lodger.water_consumption unless r[:rate_water_declaration].nil?
        @rates[rate] = 1 unless r[:rate_constant].nil?
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @lodger }
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
