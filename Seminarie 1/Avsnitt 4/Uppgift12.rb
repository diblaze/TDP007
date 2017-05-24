
def regnr(s)
  #matches regnr, but without error checking if it is 100% a swedish plate
  reg = /[A-Z]{3}\d{3}/.match(s)
  if(reg == nil)
    return false
  end
  return reg[0]
end
