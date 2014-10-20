# encoding: utf-8
class HomeController < ApplicationController
  def index
    @hipims_data = [
      [
        1,"Ti","Ti",
        "Ti靶",500,0.4,0.2,
        nil,nil,nil,nil,
        65,nil,nil,nil
      ],
      [
        2,"Ti","Ti",
        "Ti靶",550,1.1,0.6,
        nil,nil,nil,nil,
        65,nil,nil,nil
      ],
      [
        3,"Ti","Ti",
        "Ti靶",600,2,1.1,
        nil,nil,nil,nil,
        65,nil,nil,nil
      ]
    ]
  end
end
