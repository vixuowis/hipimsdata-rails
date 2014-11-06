# encoding: utf-8
class ItemsController < ApplicationController
  def index
    items = Item.order("created_at desc").all
    @hipims_data = []
    items.each do |item|
      item_hash = {}
      item_hash[:id] = item.id
      item_hash[:c1] = [item.name,nil,nil]
      item_hash[:c2] = [nil]*15
      item_hash[:c3] = [nil]*5
      item_hash[:c4] = [nil]*8
      item_hash[:c5] = [nil]*2
      puts item.name
      @hipims_data.push(item_hash)
    end
    
    # @hipims_data = [
    #   {
    #     :c1=>[1,"Ti","Ti"],
    #     :c2=>["Ti靶",500,0.4,0.2,
    #           nil,nil,nil,nil,
    #           65,nil,nil,nil,
    #           "%.2e"%0.005,nil,0.4],
    #     :c3=>["12cm","%.2e"%0.02501019799,
    #           "%.2e"%7.8025,"%.2e"%45336000000,6.4827],
    #     :c4=>["Ti","%.2e"%1693,"%.2e"%3435.1,2.029,
    #           nil,nil,nil,nil],
    #     :c5=>["#{"%.2e"%0.417528}A/m^2","#{"%.2e"%8.1463}eV"]
    #   },
    #   {
    #     :c1=>[2,"Ti","Ti"],
    #     :c2=>["Ti靶",550,1.1,0.6,
    #           nil,nil,nil,nil,
    #           65,nil,nil,nil,
    #           "%.2e"%0.005,nil,0.4],
    #     :c3=>["12cm","%.2e"%0.02501019799,
    #           "%.2e"%10.72,"%.2e"%57781000000,7.53],
    #     :c4=>["Ti","%.2e"%11122,"%.2e"%41777,3.7564,
    #           nil,nil,nil,nil],
    #     :c5=>["#{"%.2e"%0.365781}A/m^2","#{"%.2e"%12.4586}eV"]
    #   },
    #   {
    #     :c1=>[3,"Ti","Ti"],
    #     :c2=>["Ti靶",600,2,1.1,
    #           nil,nil,nil,nil,
    #           65,nil,nil,nil,
    #           "%.2e"%0.005,nil,0.4],
    #     :c3=>["12cm","%.2e"%0.02501019799,
    #           "%.2e"%7.8025,"%.2e"%45336000000,6.4827],
    #     :c4=>["Ti","%.2e"%12145,"%.2e"%58258,4.7971,
    #           nil,nil,nil,nil],
    #     :c5=>["#{"%.2e"%0.374501}A/m^2","#{"%.2e"%20.8004}eV"]
    #   }
    # ]
  end

  def new
    @item = Item.create({:name=>Time.now.to_i})
    @item.save
    redirect_to "/items/#{@item[:id]}/edit"
  end

  def show # show certain
    redirect_to "/items/#{params[:id]}/edit"
  end

  def edit # edit certain
    id = params[:id] rescue nil
    @item = Item.find_by(id: id)
    # redirect_to "/" if @item.nil?
  end

  def destroy
    id = params[:id].to_i rescue nil
    item = Item.find_by(id: id)
    if !item.nil?
      item.destroy
    end
    # redirect_to "/items"
  end
end
