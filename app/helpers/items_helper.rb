# encoding: utf-8
require 'Date'

module ItemsHelper

  def vix_time(time)
    begin
      ret_str = ""
      time = time.localtime
      if time.year == Time.now.year
        this_date = time.to_date
        today = Time.now.localtime.to_date
        if this_date == today
          time.strftime("今天 %T")
        elsif this_date == today.yesterday
          time.strftime("昨天 %T")
        elsif this_date == today.yesterday.yesterday
          time.strftime("前天 %T")
        else
          time.strftime("%m-%d %T")
        end
      else
        time.strftime("%F %T")
      end
    rescue
      nil
    end
  end

end
