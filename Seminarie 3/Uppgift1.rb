class Person
  def initialize(car_model, zip_code, years_of_license, gender_of_person, age_of_person)
    @car_model = car_model
    @zip_code = zip_code
    @years_of_license = years_of_license
    @gender_of_person = gender_of_person
    @age_of_person = age_of_person
    @points = 0
  end

  def evaluate_policy(filename)
    # Read entire policy file first
    instance_eval(File.new(filename).read)
    # Calculate extra steps
    calculate_extra
    # Return points
    @points
  end

  def calculate_extra
    @points *= 0.9 if @gender_of_person == 'M' && @years_of_license < 3
    @points *= 1.2 if @car_model == 'Volvo' && @zip_code.start_with?('58')
  end

  def car(car_model, point)
    @points += point if @car_model == car_model
  end

  def zip(zip_code, point)
    @points += point if @zip_code == zip_code
  end

  def license_age(age_range, point)
    @points += point if age_range === @years_of_license
  end

  def gender(gender_of_person, point)
    @points += point if @gender_of_person == gender_of_person
  end

  def age(age_range, point)
    @points += point if age_range === @age_of_person
  end

  # Can be done with "method_missing"
end
