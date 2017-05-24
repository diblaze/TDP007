def longest_string(strings)
    strings.max_by(&:length)
    #also doable by using inject
    #strings.inject { |first, second| first.length > second.length ? first : second }
end
