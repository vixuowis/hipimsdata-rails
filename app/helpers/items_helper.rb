# encoding: utf-8
require 'date'

module ItemsHelper

  def vix_time(time)
    begin
      time = time.localtime
      case time.hour
        when 0..2 then daystep = "深夜"
        when 3..5 then daystep = "凌晨"
        when 6..8 then daystep = "早晨"
        when 9..11 then daystep = "上午"
        when 12..14 then daystep = "中午"
        when 15..17 then daystep = "下午"
        when 18..20 then daystep = "傍晚"
        when 21..23 then daystep = "晚上"
      end

      if time.year == Time.now.year
        this_date = time.to_date
        today = Time.now.localtime.to_date
        case this_date
          when today then time.strftime("今天#{daystep} %T")
          when today.yesterday then time.strftime("昨天#{daystep} %T")
          when today.yesterday.yesterday then time.strftime("前天#{daystep} %T")
          else time.strftime("%m-%d #{daystep} %T")
        end
      else
        time.strftime("%F #{daystep} %T")
      end
    rescue
      nil
    end
  end

end
