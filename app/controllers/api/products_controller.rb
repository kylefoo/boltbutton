class Api::ProductsController < Api::BaseController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :find_product, only: [:order]
  skip_before_filter :verify_authenticity_token, :only => [:order]
  
  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to api_product_path(@product), notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def order
    data = JSON.parse(request.body.read)
    bill = Billplz::Bill.new({ name: data['name'], amount: data['amount'], collection_id: data['collection_id'], email: data['email'], description: data['description'], callback_url: data['www.boltbutton.com'], deliver: true })
    
      if bill.create
        # format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
        #format.json {render :show, status: :ok, location: api_product_path(@product)  }
        render json: @product, status: :ok 
      else
        render json: @product.errors, status: :unprocessable_entity 
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    def find_product
      @product = Product.find(params[:product_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :slug, :sku, :category_id)
    end
end
