class HomeController < ApplicationController
  def index
    @file = File.open("i/001.TXT")
  end
end
