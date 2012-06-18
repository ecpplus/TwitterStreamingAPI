class Word
  include Mongoid::Document
  field :text, type: String
  field :positive, type: Boolean
  index :text, :unique => true


  class << self
    def positive_words
      @@positive_words ||= File.open("#{Rails.root}/doc/pn.csv.m3.120408.trim").each_line \
        .map(&:strip).map{|l| l.split(/\t/)}.select{|l| l[1] == 'p'}.map{|l| l[0]}.uniq.compact \
        .map{|w| /#{w}/}
    end

    def negative_words
      @@negative_words ||= File.open("#{Rails.root}/doc/pn.csv.m3.120408.trim").each_line \
        .map(&:strip).map{|l| l.split(/\t/)}.select{|l| l[1] == 'n'}.map{|l| l[0]}.uniq.compact \
        .map{|w| /#{w}/}
    end
      
  end

end
