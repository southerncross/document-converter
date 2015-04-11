#!/bin/ruby
# -*- coding: utf-8 -*-

require "pg"

require "./converter.rb"

class Infuser
  include Converter

  def initialize(name)
    @@monthMap = {
      "一月": 1,
      "二月": 2,
      "三月": 3,
      "四月": 4,
      "五月": 5,
      "六月": 6,
      "七月": 7,
      "八月": 8,
      "九月": 9,
      "十月": 10,
      "十一月": 11,
      "十二月": 12,
    }
    @srcName = name
    @conn = PG.connect(dbname: "pku")
    @conn.prepare('insert', "INSERT INTO history (year, month, day, story) VALUES ($1, $2, $3, $4)")
  end

  def insert(y, m, d, c)
    unless c.empty?
      @conn.exec_prepared('insert', [y, m, d, c])
      puts "INSERT #{y}-#{m}-#{d} #{c}"
    end
  end

  def infuse
    year = 0
    month = 0
    day = 0
    content = ""

    File.foreach(@srcName, encoding: "UTF-8") do |line|

      line = f2h line

      if line == "\n"
        next
      end

      if line =~ /(北京大学大事记|^)\d{4}年/
        content = ""
        year = line[line.index(/\d{4}/), line.index("年")].to_i
        next
      end

      if line =~ /^(一|二|三|四|五|六|七|八|九|十|十一|十二)月$/
        insert(year, month, day, content)
        content = ""
        @@monthMap.each do |k, v|
          if line.match(k.to_s)
            month = v
            break
          end
        end
        next
      end

      if line =~ /^\d{1,2}月\d{1,2}日/
        insert(year, month, day, content)
        content = ""
        month = line[0, line.index("月")].to_i
        day = line[line.index("月") + 1, line.index("日")].to_i
        line.sub!(/^\d{1,2}月\d{1,2}日/, "")
        content << line
        next
      end

      if line =~ /^\d{1,2}月/
        insert(year, month, day, content)
        content = ""
        month = line[0, line.index("月")].to_i
        day = 0
        line.sub!(/^\d{1,2}月/, "")
        content << line
        next
      end

      content << line.strip
    end

    insert(year, month, day, content)
    content = ""

    @conn.finish
  end
end

Dir.foreach("./input") do |name|
  Infuser.new("./input/#{name}").infuse if name.match(/^(\w)+\.txt/)
end
