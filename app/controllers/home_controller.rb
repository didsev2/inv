class HomeController < ApplicationController
  def index
    @id = 0
    @file_name = "001.TXT"
    @file = File.open("i/" + @file_name)
  end
end
