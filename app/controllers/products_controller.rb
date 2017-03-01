class ProductsController < ApplicationController
  # before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.order('id DESC').first 10
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
  if params[:search] && params[:keyword].present?
    @search_keyword = params[:search].split(',') - [""]
    # if @search_keyword.size > 1
    @search_keyword.each do |ks|

      @serach_k = ks
      searching(@serach_k)
      @product = Product.create(title: @title, description: @discription, url: @url, search: @serach_k)
    end

  # end
  else
    @search = params[:search]
    searching(@search)
    @product = Product.create(title: @title, description: @discription, url: @url, search: @search)
  end
  redirect_to root_path
  end
end

def searching(search)

  client = Mechanize.new
  @title = []
  @url = []
  @discription = []
  (1..531).step(10) do |p|
    client.get("https://www.bing.com/search?q=#{search}&first=#{p}") do |page|
      document = Nokogiri::HTML::Document.parse(page.body)
      alldata = document.css('li.b_algo') rescue ""
      alldata.each do |ad|
        @title << ad.at('a').text  rescue ""
        @discription << ad.at('p').text rescue ""
        @url << ad.at('a')['href'].to_s  rescue ""
      end
    end
  end
end
