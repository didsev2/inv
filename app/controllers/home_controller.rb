class HomeController < ApplicationController
  def index
    @book_count = 0
    file_count = 1
    file_exist = 1
    files_names = []
    while file_exist == 1 do                                                    #Формирование списка файлов
      names_now = '000'
      names_now[2 - file_count.to_s.length + 1, file_count.to_s.length] = file_count.to_s
      if FileTest::exist?("i/" + names_now + ".TXT")
        files_names[file_count-1] = names_now + ".TXT"
      elsif FileTest::exist?("i/" + names_now + ".pwd")
        files_names[file_count-1] = names_now + ".pwd"
      elsif FileTest::exist?("i/" + names_now + ".txt")
        files_names[file_count-1] = names_now  + ".txt"
      else
        file_exist = 0
      end
      file_count += 1
    end

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
      elsif i[4,3] == "txt"
        original_file = File.open("i/" + i, 'r')
        original_file.each_line do |line|
          @book_count += 1
        end
        FileUtils.copy("i/" + i[0,3] + ".txt", "i/R/")
      end
    end

    count = 1
    @table = Array.new(@book_count + 1).map! { Array.new(2) }
    files_names.each do |i|
        file = File.open("i/R/" + i[0,3] + '.txt')
        stelaj_index = 1
        file.each_line do |line|
          @table[count][0] = stelaj_index
          @table[count][1] = i[0,3]
          @table[count][2] = line
          stelaj_index += 1
          count += 1
        end
        file.close
    end

    @type_errors = Array(3)
    for i in 1..(count - 1)
      @type_errors[1] = 1 if @table[i][2].size < 14
      @type_errors[2] = 1 if @table[i][2][0,2] != '20' and @table[i][2][0,3] != '978'
      @type_errors[3] = 1 if @table[i][2][0,3] == '978'
    end

    #     0 номер стеллажа
    #     1 всего книг на стеллаже
    #     2 порядковый номер книги с ошибочным штрихом
    #     3 ошибочный штрих
    #     4 номер строки штриха до ошибочного
    #     5 номер строки штриха после ошибочного
    @errors = Array.new(500).map! { Array.new(5) }
    @error_count = 0
    for i in 1..(count - 1)
      if @table[i][2].size < 14 or @table[i][2][0,2] != '20'
        @errors[@error_count][0] = @table[i][1]
        i2 = 0
        for f in 1..(count - 1)
          i2 += 1 if @table[f][1] == @table[i][1]
        end
        @errors[@error_count][1] = i2
        @errors[@error_count][2] = @table[i][0]
        @errors[@error_count][3] = @table[i][2].to_s
        @errors[@error_count][4] = @table[i-1][2].to_s
        @errors[@error_count][5] = @table[i+1][2].to_s
        @error_count += 1
      end
    end
      Dir.mkdir("i/Резерв") if !FileTest::exist?("i/Резерв")                    #Удаление папки i/Резерв в случае если она существует

      files_names.each do |i|
        if FileTest::exist?("i/" + i[0,3] + '.TXT') or FileTest::exist?("i/" + i[0,3] + '.pwd')
          FileUtils.move("i/" + i, "i/Резерв/" + i)
          FileUtils.move("i/R/" + i[0,3] + '.txt', "i/")
        end
      end

    if @error_count == 0
      file = File.new("i/Сводный.txt", 'w')
      for i in 1..(count - 1)
        file.puts @table[i][1] + " " + @table[i][2]
      end
      file.close
    end
    FileUtils.rm_r('i/R')
  end
end
