require 'date'

class PersonName
  def initialize(name = '')
    self.fullname = name
  end

  def fullname
    "#{@name} #{@surname}"
  end

  def fullname=(name)
    # doesnt work?
    # @name, @surname = name.split
    strings = name.split
    @name = strings[0].to_s
    @surname = strings[1].to_s
  end
end
