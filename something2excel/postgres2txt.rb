#!/bin/ruby
# -*- coding: utf-8 -*-

require "pg"
require "Date"

conn = PG.connect dbname: "pku"

Dir.mkdir "./output" unless Dir.exist? "./output"

Date.new(2000, 01, 01).upto(Date.new(2000, 12, 31)) do |date|
  sql = "SELECT year, story FROM history WHERE month=#{date.mon} AND day=#{date.day} ORDER BY year"
  name = "/Users/lishunyang/workspace/interesting/something2excel/output/#{date.mon}月#{date.day}日.txt"

  File.open(name, "w") do |file|
    conn.exec(sql).each do |row|
      file.printf "%s\n%s\n\n", row["year"].sub(/\n/, ""), row["story"].strip
    end
  end
end
