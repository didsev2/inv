class HomeController < ApplicationController
  def index
    @book_count = 0
    file_count = 1
    file_exist = 1
    files_names = []
    while file_exist == 1 do
      names_now = '000'
      names_now[2 - file_count.to_s.length + 1, file_count.to_s.length] = file_count.to_s
      if FileTest::exist?("i/" + names_now + ".TXT")
        names_now = names_now + ".TXT"
        files_names[file_count-1] = names_now
      elsif FileTest::exist?("i/" + names_now + ".pwd")
        names_now = names_now + ".pwd"
        files_names[file_count-1] = names_now
      else
        file_exist = 0
      end
      file_count += 1
    end
    files_names[file_count-2] = "" if file_exist == 0

    FileUtils.rm_r('i/R') if FileTest::exist?("i/R")                            #Удаление папки i/R в случае если она существует
    Dir.mkdir("i/R")                                                            # Создание папки i/R

    files_names.each do |i|
      if i[4,3] == "TXT"
        file = File.new("i/R/" + i[0,3] + ".txt", 'w')
        original_file = File.open("i/" + i, 'r')
        original_file.each_line do |line|
          regex = /^(\d{3,})/.match (line)
          file.puts regex[1]
          @book_count += 1
        end
        file.close
        original_file.close
      elsif i[4,3] == "pwd"
        file = File.new("i/R/" + i[0,3] + ".txt", 'w')
        original_file = File.open("i/" + i, 'r')
        original_file.each_line do |line|
          regex = /^(\d{3,})/.match (line)
          if regex != nil
            file.puts regex[1]
            @book_count += 1
          end
        end
        file.close
        original_file.close
      end
    end

    count = 1
    @error_count = 0
    @table = Array.new(@book_count + 1).map! { Array.new(2) }
#0 номер стеллажа, 1 всего книг на стеллаже, 2 индекс ошибочного штриха, 3 ошибочный штрих, 4 штрих до, 5 штрих после
    @errors = Array.new(500).map! { Array.new(5) }
    @error_count = 0

    files_names.each do |i|
      if i != ""
        file = File.open("i/R/" + i[0,3] + '.txt')
        i2 = 0
        file.each_line do |all_books|
          i2 += 1
        end
        file.close

        file = File.open("i/R/" + i[0,3] + '.txt')
        stelaj_index = 1
        file.each_line do |line|
          @table[count][0] = stelaj_index
          @table[count][1] = i[0,3]
          @table[count][2] = line
          if line.size < 14
            @errors[@error_count][0] = i[0,3]
            @errors[@error_count][1] = i2
            @errors[@error_count][2] = stelaj_index
            @errors[@error_count][3] = line
            @error_count += 1
          end
          stelaj_index += 1
          count += 1
        end
        file.close
      end
    end
  end
end
