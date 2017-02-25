class ProductsController < ApplicationController
  # before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  def download
    zip_data = File.read("#{Rails.root}/public/uploads/reports/#{params[:id]}.csv")
    send_data(zip_data, type: 'application/zip', filename: "#{params[:id]}.csv")
  end

  # GET /products/1
  # GET /products/1.json

  # GET /products/new
  def new
    @product = Product.new
  end

  def destroy
  Product.find(params[:id]).destroy
   redirect_to products_path


  end

  def show
    @product = Product.find(params[:id]) rescue ""  
  end


  # GET /products/1/edit


  # POST /products
  # POST /products.json
  def create
      # browser = Watir::Browser.new :firefox 
      @search = params[:search]
      client = Mechanize.new

          @title = []
          @url = []
          @discription = []
      (1..531).step(10) do |p|
        client.get("https://www.bing.com/search?q=#{@search}&first=#{p}") do |page|

          document = Nokogiri::HTML::Document.parse(page.body)
          alldata = document.css('li.b_algo') rescue ""

          alldata.each do |ad|
            @title << ad.at('a').text  rescue ""
            @discription << ad.at('p').text rescue ""
            @url << ad.at('a')['href'].to_s  rescue ""
          end
        end
      end

      @product = Product.create(title: @title, description: @discription, url: @url, search: @search)

      # CSV.open("#{Rails.root}/public/uploads/reports/#{@product.id}.csv", "wb") do |csv| 
      # csv << ["Title", "Discription", "Url"] 
      # (0..@title.length).each do |index| 
      # csv << [@title[index], @discription[index], @url[index]] 
      # end 
      # end 


    # format.csv do
    #   response.headers['Content-Type'] = 'text/csv'
    #   response.headers['Content-Disposition'] = 'attachment; filename=file.csv'    
    #   render :template => "/home/vishal/Downloads/file.csv"
    # end
      redirect_to products_path
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
 
end
