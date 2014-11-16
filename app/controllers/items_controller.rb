# encoding: utf-8
require 'fileutils'

class ItemsController < ApplicationController
  def index
    items = Item.order("created_at desc")
    @hipims_data = []
    items.each do |item|
      puts "#{item.c1.to_s} #{item.c2.to_s}"
      item_hash = {}
      item_hash[:id] = item.id
      item_hash[:name] = item.name
      col1 = nil; col2 = nil;
      col1 = JSON.parse(item.c1) if item.c1 rescue nil
      col2 = JSON.parse(item.c2) if item.c2 rescue nil
      item_hash[:c1] = [item.name,nil,nil]
      if !col1.nil?
        # puts "col1 = #{col1.to_s}"
        col1.each_with_index do |i, index|
          item_hash[:c1][index] = i[1] if i[1]!="" rescue nil
        end
      end
      item_hash[:c2] = [nil]*15
      if !col2.nil?
        item_hash[:c2][0..3] = fit_item(4,col2,"elem1_1")
        item_hash[:c2][4..7] = fit_item(4,col2,"elem1_2")
        item_hash[:c2][8..11] = fit_item(4,col2,"elem2")
        item_hash[:c2][12..14] = fit_item(3,col2,"elem3")
      end
      puts item_hash.to_s
      @hipims_data.push(item_hash)
    end
  end

  def fit_item(num, col, elem_str)
    if col[elem_str].nil?
      return [nil]*num
    else
      ret_arr = []
      col[elem_str].each do |k,v|
        if v==""
          ret_arr.push(nil)
          next
        end
        ret_arr.push(v)
      end
      return ret_arr
    end
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
    begin
      find_item_and_process
      update_col
    rescue
    end
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
    begin
      if col == "1" and !val['no'].nil?
        @item.name = val['no'] ; 
        @item.save;
      elsif col == "2"
        val_old = JSON.parse(@item.c2)
        val = val_old.merge(val)
      elsif col == "3" 
        val_old = JSON.parse(@item.c3)
        val = val_old.merge(val)
      elsif col == "4"
        val_old = JSON.parse(@item.c4)
        val = val_old.merge(val)
      elsif col == "5"
        val_old = JSON.parse(@item.c5)
        val = val_old.merge(val)
      end
    rescue
    end
    val_json = val.to_json
    @item.update_column("c#{col}".to_sym, val_json)
    @item.updated_at = Time.now
    @item.save
  end

  def upload_file
    if !params['c4_whole'].nil?
      tmp = params['c4_whole']
    elsif !params['c4_fine'].nil?
      tmp = params['c4_fine']
    end
    
    File.open(Rails.root.join('public', 'uploads', tmp.original_filename), 'wb') do |file|
      file.write(tmp.read)
    end

    redirect_to "/items/#{params[:id]}/edit"
  end

end

