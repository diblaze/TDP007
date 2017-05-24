class String
  def acronym
    stringToReturn = ''
    #split the string and then for each word make it uppercase and add to acronym string
    split.each { |word| stringToReturn += word[0].upcase }
    stringToReturn
  end
end
