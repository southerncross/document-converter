#!/bin/ruby
# -*- coding: utf-8 -*-

require "spreadsheet"

Spreadsheet.client_encoding = "UTF-8"

startYear = 1913
endYear = 1996

Dir.mkdir "./excel" unless Dir.exist? "./excel"

Dir.foreach("./output") do |name|
  next unless name.match(/\d{1,2}月\d{1,2}日/)
  excel = Spreadsheet::Workbook.new
  sheet = excel.create_worksheet name: "大事记"
  File.open("./output/#{name}") do |file|
    i = 0
    while line = file.gets
      next if line.empty?
      if line.match(/^\d{4}$/)
        i += 1
        sheet[i, 0] = line
      else
        sheet[i, 1] = sheet[i, 1] ? sheet[i, 1] + line : line
      end
    end
  end
  name.sub!(/txt/, "xls")
  excel.write "./excel/#{name}"
end
