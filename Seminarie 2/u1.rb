# coding: utf-8

def print_arr(arr)
  count = 1

  puts "Minst skillnad mellan antal gjorde och insläppta mål:"
  arr[0].each do |item|
    print item + " "
  end
  puts "\n\n"
  
  arr[1].each do |items|
    print count.to_s + ". "

    items.each do |item|
      print item + " "
    end
    
    count += 1
    print "\n"
  end
end

  


def create_table(path)
  data = File.read(path)

  # Status = 0 om vi inte hittat <pre> än
  # Status = 1 om vi hittat <pre>
  # Status = 2 om vi ska börja spara till array:en
  status = 0

  # Blir en 2D-array i loopen längre ner.
  arr = []

  # Gå igenom varje rad
  data.each_line do |line|
    status = 1 if line == "<pre>\n"

    if status == 1 || status == 2
      if status == 2
        arr.push([])
      end

      # Gör om raden till en array av ord
      words = line.split

      # Gå igenom varje ord
      words.each_with_index do |word, index|
        if status == 2
          arr.last.push(word) if index != 0
        end
        
        if word == "Pts"
          status = 2
        end
      end
    end
  end


  # Sortera
  sorted = arr.sort {|a,b| (b[5].to_i() - b[7].to_i()) <=> (a[5].to_i() - a[7].to_i()) }

  max = arr[0]

  # Ta bort tomma element
  sorted.each do |items|
    if items.join("") == ""
      sorted.delete(items)
      next
    end
  end

  # Hitta minsta skillnaden
  sorted.each do |items|
    if (items[5].to_i() - items[7].to_i()).abs < (max[5].to_i() - max[7].to_i()).abs
      max = items
    end
  end
  
  return [max, sorted]
end

# Väder

def print_weather_table(arr)
  count = 1

  puts "Minst skillnad mellan MxT och MnT"
  arr[0].each do |item|
    print item + " "
  end
  puts "\n\n"
  
  arr[1].each do |items|
    print count.to_s + ". "

    items.each do |item|
      print item + " "
    end
    
    count += 1
    print "\n"
  end

end

def create_weather_table(path)
  data = File.read(path)
  # Status = 0 om vi inte kommit till <pre>
  # Status = 1 om vi har kommit till <pre>
  # Status = 2 om vi ska börja sparra till "arr"
  status = 0
  arr = []

  # Gå igenom varje rad
  data.each_line do |line|
    status = 1 if line == "<pre>\n"

    if status == 1 || status == 2
      if status == 2
        arr.push([])
      end

      words = line.split

      words.each_with_index do |word, index|
        if status == 2
          arr.last.push(word) if index != 0
        end

        if word == "AvSLP"
          status = 2
        end
      end
    end
  end

  sorted = arr.sort {|a,b| (b[2].to_i() - b[1].to_i()) <=> (a[2].to_i() - a[1].to_i()) }



  # Ta bort tomma element
  sorted.each do |items|
    if items.join("") == ""
      sorted.delete(items)
      next
    end
  end

  max = sorted[0]
  
  # Hitta minsta skillnaden
  sorted.each do |items|
    if (items[2].to_i() - items[1].to_i()).abs < (max[2].to_i() - max[1].to_i()).abs
      max = items
    end
  end
  
  return [max, sorted]
end

