#!/usr/bin/env ruby
# coding: iso-8859-1

# ----------------------------------------------------------------------------
#  Unidirectional constraint network for logic gates
# ----------------------------------------------------------------------------

# This is a simple example of a constraint network that uses logic gates.
# There are three classes of gates: AndGate, OrGate, and NotGate.
# Connections between gates are modelled as the class Wire.

require 'logger'

class BinaryConstraint
  def initialize(input1, input2, output)
    @input1 = input1
    @input1.add_constraint(self)
    @input2 = input2
    @input2.add_constraint(self)
    @output = output
    new_value
  end
end

class AndGate < BinaryConstraint
  def new_value
    sleep 0.2
    @output.value = (@input1.value && @input2.value)
  end
end

class OrGate < BinaryConstraint
  def new_value
    sleep 0.2
    @output.value = (@input1.value || @input2.value)
  end
end

class NotGate
  def initialize(input, output)
    @input = input
    @input.add_constraint(self)
    @output = output
    new_value
  end

  def new_value
    sleep 0.2
    @output.value = !@input.value
  end
end

class Wire
  attr_accessor :name
  attr_reader :value

  def initialize(name, value = false)
    @name = name
    @value = value
    @constraints = []
    @logger = Logger.new(STDOUT)
  end

  def log_level=(level)
    @logger.level = level
  end

  def add_constraint(gate)
    @constraints << gate
  end

  def value=(value)
    @logger.debug("#{name} = #{value}")
    @value = value
    @constraints.each(&:new_value)
  end
end

# ----------------------------------------------------------------------------
#  Bidirectional constraint network for arithmetic constraints
# ----------------------------------------------------------------------------

# In the example above, our constraint network was unidirectional.
# That is, changes could not propagate from the output wire to the
# input wires. However, to model equation systems such as the
# correlation betwen the two units of measurement Celsius and
# Fahrenheit, we need to propagate changes from either end to the
# other.

#module PrettyPrint
  # To make printouts of connector objects easier, we define the
  # inspect method so that it returns the value of to_s. This method
  # is used by Ruby when we display objects in irb. By defining this
  # method in a module, we can include it in several classes that are
  # not related by inheritance.

  #def inspect
   # "#<#{self.class}: #{self}>"
  #end
#end

# This is the base class for Adder and Multiplier.

class ArithmeticConstraint
  attr_accessor :a, :b, :out
  attr_reader :logger, :op, :inverse_op

  def initialize(a, b, out)
    @logger = Logger.new(STDOUT)
    @a = a
    @b = b
    @out = out
    [a, b, out].each { |x| x.add_constraint(self) }
  end

  def to_s
    "#{a} #{op} #{b} == #{out}"
  end

  def new_value(connector)
    if [a, b].include?(connector) && a.has_value? && b.has_value? &&
       !out.has_value?
      # Inputs changed, so update output to be the sum of the inputs
      # "send" means that we send a message, op in this case, to an
      # object.
      val = a.value.send(op, b.value)
      logger.debug("#{self} : #{out} updated")
      out.assign(val, self)
    elsif [b, out].include?(connector) && b.has_value? && out.has_value? &&
          !a.has_value?
      # a is out, b and c got value, update output to be c - b.
      val = out.value.send(inverse_op, b.value)
      logger.debug("#{out} #{inverse_op} #{b} == #{a} : #{a} updated")
      a.assign(val, self)
    elsif [a, out].include?(connector) && a.has_value? && out.has_value? &&
          !b.has_value?
      val = out.value.send(inverse_op, a.value)
      logger.debug("#{out} #{inverse_op} #{a} == #{b} : #{b} updated")
      b.assign(val, self)
    end
    self
  end

  # A connector lost its value, so propagate this information to all
  # others
  def lost_value(connector)
    ([a, b, out] - [connector]).each { |connector| connector.forget_value(self) }
  end
end

class Adder < ArithmeticConstraint
  def initialize(*args)
    super(*args)
    @op = :+
    @inverse_op = :-
  end
end

class Multiplier < ArithmeticConstraint
  def initialize(*args)
    super(*args)
    @op = :*
    @inverse_op = :/
  end
end

class ContradictionException < RuntimeError
end

# This is the bidirectional connector which may be part of a constraint network.

class Connector
  attr_accessor :name, :value

  def initialize(name, value = false)
    self.name = name
    @has_value = !value.eql?(false)
    @value = value
    @informant = false
    @constraints = []
    @logger = Logger.new(STDOUT)
  end

  def add_constraint(c)
    @constraints << c
  end

  # Values may not be set if the connector already has a value, unless
  # the old value is retracted.
  def forget_value(retractor)
    if @informant == retractor
      @has_value = false
      @value = false
      @informant = false
      @logger.debug("#{self} lost value")
      others = (@constraints - [retractor])
      @logger.debug("Notifying #{others}") unless others == []
      others.each { |c| c.lost_value(self) }
      'ok'
    else
      @logger.debug("#{self} ignored request")
    end
  end

  def has_value?
    @has_value
  end

  # The user may use this procedure to set values
  def user_assign(value)
    forget_value('user')
    assign value, 'user'
  end

  def assign(v, setter)
    if !has_value?
      @logger.debug("#{name} got new value: #{v}")
      @value = v
      @has_value = true
      @informant = setter
      (@constraints - [setter]).each { |c| c.new_value(self) }
      'ok'
    else
      if value != v
        raise ContradictionException, "#{name} already has value #{value}.\nCannot assign #{name} to #{v}"
    end
  end
  end

  def to_s
    name
  end
end

class ConstantConnector < Connector
  def initialize(name, value)
    super(name, value)
    @logger.warn "Constant #{name} has no value!" unless has_value?
  end

  def value=(_val)
    raise ContradictionException, 'Cannot assign a constant a value!'
  end
end

# ----------------------------------------------------------------------------
#  Assignment
# ----------------------------------------------------------------------------

# text got corrupted.

def celsius2fahrenheit
  # formel = C * 9/5 + 32

  # Temperature connectors
  celsius = Connector.new('c')
  fahrenheit = Connector.new('f')

  # We can use ConstantConnector to... well... use constants.
  divider_const = ConstantConnector.new('divider', (9.0 / 5.0))
  adder_const = ConstantConnector.new('adder', 32)

  # Create a new connect that holds the temperature
  temperature = Connector.new('temp')

  # Multiply the celsius value by dividerConst
  # c * 9/5
  Multiplier.new(celsius, divider_const, temperature)
  # Add the 32 constant to get fahrenheit
  # c + 32 = f
  Adder.new(temperature, adder_const, fahrenheit)

  [celsius, fahrenheit]
end

# Ni kan dÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂ¯ÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂ¿ÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂ½ anvÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂ¯ÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂ¿ÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂ½nda funktionen sÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂ¯ÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂ¿ÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂ½ hÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂ¯ÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂ¿ÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂ½r:

# irb(main):1988:0> c,f=fahrenheit2celsius
# <nÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂ¯ÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂ¿ÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂ½gonting returneras>
# irb(main):1989:0> c.user_assign 100
# D, [2007-02-08T09:15:01.971437 #521] DEBUG -- : c ignored request
# D, [2007-02-08T09:15:02.057665 #521] DEBUG -- : c got new value: 100
# D, [2007-02-08T09:15:02.058046 #521] DEBUG -- : c * 9 == 9c : 9c updated
# D, [2007-02-08T09:15:02.058209 #521] DEBUG -- : 9c got new value: 900
# D, [2007-02-08T09:15:02.058981 #521] DEBUG -- : f-32 * 5 == 9c : f-32 updated
# D, [2007-02-08T09:15:02.059156 #521] DEBUG -- : f-32 got new value: 180
# D, [2007-02-08T09:15:02.059642 #521] DEBUG -- : f-32 + 32 == f : f updated
# D, [2007-02-08T09:15:02.059792 #521] DEBUG -- : f got new value: 212
# "ok"
# irb(main):1990:0> f.value
# 212
# irb(main):1991:0> c.user_assign 0
# D, [2007-02-08T09:15:19.433621 #521] DEBUG -- : c lost value
# D, [2007-02-08T09:15:19.501880 #521] DEBUG -- : Notifying c * 9 == 9c
# D, [2007-02-08T09:15:19.502214 #521] DEBUG -- : 9 ignored request
# D, [2007-02-08T09:15:19.502380 #521] DEBUG -- : 9c lost value
# D, [2007-02-08T09:15:19.502527 #521] DEBUG -- : Notifying f-32 * 5 == 9c
# D, [2007-02-08T09:15:19.502701 #521] DEBUG -- : f-32 lost value
# D, [2007-02-08T09:15:19.502863 #521] DEBUG -- : Notifying f-32 + 32 == f
# D, [2007-02-08T09:15:19.503031 #521] DEBUG -- : 32 ignored request
# D, [2007-02-08T09:15:19.503427 #521] DEBUG -- : f lost value
# D, [2007-02-08T09:15:19.503570 #521] DEBUG -- : 5 ignored request
# D, [2007-02-08T09:15:19.503699 #521] DEBUG -- : c got new value: 0
# D, [2007-02-08T09:15:19.503860 #521] DEBUG -- : c * 9 == 9c : 9c updated
# D, [2007-02-08T09:15:19.503963 #521] DEBUG -- : 9c got new value: 0
# D, [2007-02-08T09:15:19.504111 #521] DEBUG -- : f-32 * 5 == 9c : f-32 updated
# D, [2007-02-08T09:15:19.504210 #521] DEBUG -- : f-32 got new value: 0
# D, [2007-02-08T09:15:19.504356 #521] DEBUG -- : f-32 + 32 == f : f updated
# D, [2007-02-08T09:15:19.534416 #521] DEBUG -- : f got new value: 32
# "ok"
# irb(main):1992:0> f.value
# 32
# irb(main):1993:0> c.forget_value "user"
# D, [2007-02-08T09:19:56.754866 #521] DEBUG -- : c lost value
# D, [2007-02-08T09:19:56.842475 #521] DEBUG -- : Notifying c * 9 == 9c
# D, [2007-02-08T09:19:56.844665 #521] DEBUG -- : 9 ignored request
# D, [2007-02-08T09:19:56.844855 #521] DEBUG -- : 9c lost value
# D, [2007-02-08T09:19:56.845021 #521] DEBUG -- : Notifying f-32 * 5 == 9c
# D, [2007-02-08T09:19:56.845195 #521] DEBUG -- : f-32 lost value
# D, [2007-02-08T09:19:56.845363 #521] DEBUG -- : Notifying f-32 + 32 == f
# D, [2007-02-08T09:19:56.845539 #521] DEBUG -- : 32 ignored request
# D, [2007-02-08T09:19:56.845664 #521] DEBUG -- : f lost value
# D, [2007-02-08T09:19:56.845790 #521] DEBUG -- : 5 ignored request
# "ok"
# irb(main):1994:0> f.user_assign 100
# D, [2007-02-08T09:20:14.367288 #521] DEBUG -- : f ignored request
# D, [2007-02-08T09:20:14.465708 #521] DEBUG -- : f got new value: 100
# D, [2007-02-08T09:20:14.466057 #521] DEBUG -- : f-32 + 32 == f : f-32 updated
# D, [2007-02-08T09:20:14.466261 #521] DEBUG -- : f-32 got new value: 68
# D, [2007-02-08T09:20:14.466436 #521] DEBUG -- : f-32 * 5 == 9c : 9c updated
# D, [2007-02-08T09:20:14.466547 #521] DEBUG -- : 9c got new value: 340
# D, [2007-02-08T09:20:14.466714 #521] DEBUG -- : c * 9 == 9c : c updated
# D, [2007-02-08T09:20:14.468579 #521] DEBUG -- : c got new value: 37
# "ok"
# irb(main):1995:0> c.value
# 37
