require('date')
require_relative('Uppgift5')

class Person
  def initialize(_fullname, _age = 0, _birthyear = 0)
    @name = PersonName.new(_fullname)
    @age = _age
    @birthyear = _birthyear

    if (!@age.nil? && @age > 0) && (@birthyear.nil? || @birthyear == 0)
      change_age(@age)
    elsif (@age.nil? || @age == 0) && (!@birthyear.nil? && @birthyear > 0)
      change_birthyear(@birthyear)
    elsif (@age != 0 && @birthyear != 0) && @birthyear != (Date.today.year - @age)
      puts 'Birthyear and age are not matching!'
      puts "#{@age} : #{@birthyear}"
    end
  end

  def fullname
    @name.fullname
  end

  attr_reader :age

  attr_reader :birthyear

  def change_birthyear(_birthyear)
    @birthyear = _birthyear
    yearToday = Date.today.year
    @age = yearToday - _birthyear
  end

  def change_age(_age)
    @age = _age
    @birthyear = Date.today.year - @age
  end
end
