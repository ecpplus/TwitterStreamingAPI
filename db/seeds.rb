# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#positive_words = File.open("#{Rails.root}/doc/pn.csv.m3.120408.trim").each_line.map(&:strip).map{|l| l.split(/\t/)}.select{|l| l[1] == 'p'}.uniq
positive_words = File.open("#{Rails.root}/doc/pn.csv.m3.120408.trim").each_line.map(&:strip).map{|l| l.split(/\t/)}.uniq
positive_words.each do |line|
  next unless %w(p e).include?(line[1])
  Word.create!(:text => line[0], :positive => line[1] == 'p')
end

