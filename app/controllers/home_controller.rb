class HomeController < ApplicationController
  def index
    file_count = 1
    file_exist = 1
    files_names = []
    while file_exist == 1 do
      names_now = '000'
      names_now[2 - file_count.to_s.length + 1, file_count.to_s.length] = file_count.to_s
      if FileTest::exist?("i/" + names_now + ".TXT")
        names_now = names_now + ".TXT"
      elsif FileTest::exist?("i/" + names_now + ".pwd")
        names_now = names_now + ".pwd"
      else
        file_exist = 0
      end
      files_names[file_count-1] = names_now
      file_count += 1
    end
    files_names[file_count-2] = "" if file_exist == 0

    FileUtils.rm_r('i/R') if FileTest::exist?("i/R")                            #Удаление папки i/R в случае если она существует
    Dir.mkdir("i/R")                                                            # Создание папки i/R

    files_names.each do |i|
      if i[4,3] == "TXT"
        file = File.new("i/R/" + i[0,3] + ".txt", 'w')
        file.puts "ета ТХТшычный файличег"
        file.close
      elsif i[4,3] == "pwd"
        file = File.new("i/R/" + i[0,3] + ".txt", 'w')
        file.puts "а ета ПВДшычный фаличег... ага.... "
        file.close
      end
    end



    @count = 1
    @table = Array.new().map! { Array.new(3) }

    files_names.each do |i|
      file_name = i.to_s
      file = File.open("i/" + file_name)
      if file_name[4,3] == 'TXT'
        file_name.each_line do |line|
          @table[@count,1] = @count
          @table[@count,2] = file_name[0,3]
          @table[@count,3] = line.split[0]
        end
      end
      @count += 1
    end
  end
end
