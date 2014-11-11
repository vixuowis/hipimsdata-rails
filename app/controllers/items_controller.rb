# encoding: utf-8
class ItemsController < ApplicationController
  def index
    items = Item.order("created_at desc")
    @hipims_data = []
    items.each do |item|
      puts "#{item.c1.to_s} #{item.c2.to_s} #{item.c3.to_s} #{item.c4.to_s} #{item.c5.to_s}"
      item_hash = {}
      item_hash[:id] = item.id
      item_hash[:name] = item.name
      @col1 = nil; @col2 = nil; @col3 = nil; @col4 = nil; @col5 = nil; 
      @col1 = JSON.parse(item.c1) if item.c1 rescue nil
      @col2 = JSON.parse(item.c2) if item.c2 rescue nil
      @col3 = JSON.parse(item.c3) if item.c3 rescue nil
      @col4 = JSON.parse(item.c4) if item.c4 rescue nil
      @col5 = JSON.parse(item.c5) if item.c5 rescue nil
      item_hash[:c1] = [item.name,nil,nil]
      if !@col1.nil?
        puts "@col1 = #{@col1.to_s}"
        @col1.each_with_index do |i, index|
          item_hash[:c1][index] = i[1] if i[1]!="" rescue nil
        end
      end
      item_hash[:c2] = [nil]*15
      if !@col2.nil?
        @col2.each_with_index do |i, index|
          item_hash[:c2][index] = i[1] rescue nil
        end
      end
      item_hash[:c3] = [nil]*5
      if !@col3.nil?
        @col3.each_with_index do |i, index|
          item_hash[:c3][index] = i[1] rescue nil
        end
      end
      item_hash[:c4] = [nil]*8
      if !@col4.nil?
        @col4.each_with_index do |i, index|
          item_hash[:c4][index] = i[1] rescue nil
        end
      end
      item_hash[:c5] = [nil]*2
      if !@col5.nil?
        @col5.each_with_index do |i, index|
          item_hash[:c5][index] = i[1] rescue nil
        end
      end
      puts item_hash.to_s
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
    redirect_to "/items/#{@item[:id]}/edit"
  end

  def show # show certain
    find_item_and_process
  end

  def edit # edit certain
    find_item_and_process
  end

  def destroy
    go_check_params
    item = Item.find_by(id: @id)
    item.destroy if !item.nil?
  end

  def update_item # update 
    find_item_and_process
    update_col
    redirect_to "/items/#{params[:id]}/edit"
  end

  def go_check_params
    begin
      @id = params[:id].to_i
    rescue 
      redirect_to '/items'
    end
  end

  def find_item_and_process()
    go_check_params()
    @item = Item.find_by(id: @id)

    @col1 = JSON.parse(@item.c1) if @item.c1 rescue []
    @col2 = JSON.parse(@item.c2) if @item.c2 rescue []
    @col3 = JSON.parse(@item.c3) if @item.c3 rescue []
    @col4 = JSON.parse(@item.c4) if @item.c4 rescue []
    @col5 = JSON.parse(@item.c5) if @item.c5 rescue []
  end

  def update_col
    col = params[:col]
    val = params[:val]
    val_arr = []
    begin
      if col == "1" and !val['no'].nil?
        @item.name = val['no'] ; 
        @item.save;
      end
    rescue
    end
    val_json = val.to_json
    @item.update_column("c#{col}".to_sym, val_json)
    @item.updated_at = Time.now
    @item.save
  end
end

