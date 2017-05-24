def find_username(s)
  tmp = /: (.+)/.match(s)
  tmp = /[a-zA-Z1-9]+/.match(tmp[0])
  tmp[0]
end