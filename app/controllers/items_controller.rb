# encoding: utf-8
require 'fileutils'

class ItemsController < ApplicationController
  def index
    items = Item.order("created_at desc")
    # if params[:o] == "n_asc"
    #   items = items.reorder("name asc")
    # elsif params[:o] == "n_desc" 
    #   items = items.reorder("name desc")
    # end
    @hipims_data = []
    items.each do |item|
      puts "#{item.c1.to_s} #{item.c2.to_s}"
      item_hash = {}
      item_hash[:id] = item.id
      item_hash[:name] = item.name
      col1 = nil; col2 = nil;
      col1 = JSON.parse(item.c1) if item.c1 rescue nil
      col2 = JSON.parse(item.c2) if item.c2 rescue nil
      col3 = JSON.parse(item.c3) if item.c3 rescue nil
      col4 = JSON.parse(item.c4) if item.c4 rescue nil
      col5 = JSON.parse(item.c5) if item.c5 rescue nil

      item_hash[:c1] = [item.name,nil,nil]
      if !col1.nil?
        # puts "col1 = #{col1.to_s}"
        col1.each_with_index do |i, index|
          item_hash[:c1][index] = i[1] if i[1]!="" rescue nil
        end
      end
      item_hash[:c2] = [nil]*7
      if !col2.nil?
        item_hash[:c2][0] = col2['elem1_1']['name']
        item_hash[:c2][1] = col2['elem1_1']['v']
        item_hash[:c2][2] = col2['elem1_1']['a']
        item_hash[:c2][3] = col2['elem2']['ar']
        item_hash[:c2][4] = col2['elem2']['n']
        item_hash[:c2][5] = col2['elem3']['pianya']
        item_hash[:c2][6] = col2['elem3']['qiya']
      end
      item_hash[:c3] = [nil]*7
      if !col3.nil?
        item_hash[:c3][0] = col3['elem2']['baohe']
        item_hash[:c3][1] = col3['elem2']['midu']
        item_hash[:c3][2] = col3['elem2']['wendu']
      end
      if !col4.nil?
        item_hash[:c3][3] = col4['n_1']['name']
        item_hash[:c3][4] = col4['n_1']['chengdu']
      end
      if !col5.nil?
        item_hash[:c3][5] = col5['dianliu']
        item_hash[:c3][6] = col5['nengliang']
      end
      puts item_hash.to_s
      @hipims_data.push(item_hash)
    end

    if params[:o] == "n_asc"
      @hipims_data.sort! {|a,b| a[:name].to_i <=> b[:name].to_i}
    elsif params[:o] == "n_desc" 
      @hipims_data.sort! {|a,b| b[:name].to_i <=> a[:name].to_i}
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
    current_id = @item.id
    while true
      begin
        @item.name = current_id
        @item.save
      rescue
        current_id += 1
        next
      end
      break
    end
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
    respond_to do |format|
      format.json{render :json=>{:result=>"success"}}
    end
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
      redirect_to '/items?o=n_asc'
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
    begin
      if !params['c4_whole_1'].nil?
        tmp = params['c4_whole_1'];
        name = "c4_whole_1"
      elsif !params['c4_fine_1'].nil?
        tmp = params['c4_fine_1']
        name = "c4_fine_1"
      elsif !params['c4_whole_2'].nil?
        tmp = params['c4_whole_2']
        name = "c4_whole_2"
      elsif !params['c4_fine_2'].nil?
        tmp = params['c4_fine_2']
        name = "c4_fine_2"
      elsif !params['c5_ion'].nil?
        tmp = params['c5_ion']
        name = "c5_ion"
      else 
        redirect_to "/items/#{params[:id]}/edit"
      end
      
      json_data = []
      tmp.read.each_line do |l|
        data_row = l.split(/\t| /).map(&:strip).map(&:to_f)
        json_data.push(data_row)
      end
      # puts json_data.to_s
      graph_old = Graph.find_by(item_id: params['id'].to_i, name: name)
      if !graph_old.nil?
        puts "update"
        graph_old.data = json_data.to_json
        graph_old.save
      else
        puts "create"
        Graph.create({:item_id=>params[:id].to_i, :name=>name, :data=>json_data.to_json})
      end
      Item.find_by(id: params[:id].to_i).touch
    rescue
    end
    # File.open(Rails.root.join('public', 'uploads', tmp.original_filename), 'wb') do |file|
    #   file.write(tmp.read)
    # end
    redirect_to "/items/#{params[:id]}/edit"
  end

  def read_graph
    result = Graph.find_by(item_id: params['id'].to_i, name: params['name']).data rescue []
    puts result.to_s
    respond_to do |format|
      format.json{render :json=>result}
      format.html{render :json=>result}
    end
  end

end

