class ProductsController < ApplicationController
  before_filter :current_user  
  before_filter :admin_user
  before_filter :admin_required, :except => [:index, :show, :search]
    
  
  # GET /products
  # GET /products.json
  def index
    @featured = Product.where("featured = true").first

    @products = Product.paginate(:order => 'name', 
    :per_page => 5,
    :page => params[:page])
    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :ok }
    end
  end
  
  def search
    if params[:page].nil?
      if params[:search].nil? 
        session[:searchterm] = params[:id]
      else
        session[:searchterm] = params[:search][:searchtext]
      end
    end
    
    if request.url.index('localhost')
       @productcount = Product.count(:all, :conditions => ["name LIKE ? or description LIKE ?", '%' + session[:searchterm] + '%', '%' + session[:searchterm] + '%'])

       @products = Product.paginate(:conditions => ["name LIKE ? or description LIKE ?", '%' + session[:searchterm] + '%', '%' + session[:searchterm] + '%'], 
       :per_page => 10,
       :page => params[:page])

     else
       @productcount = Product.count(:all, :conditions => ["name ILIKE ? or description ILIKE ?", '%' + session[:searchterm] + '%', '%' + session[:searchterm] + '%'])

       @products = Product.paginate(:conditions => ["name ILIKE ? or description ILIKE ?", '%' + session[:searchterm] + '%', '%' + session[:searchterm] + '%'], 
       :per_page => 10,
       :page => params[:page])

    end
  end
  
end
