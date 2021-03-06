# step_definitions/command_line_control_steps.rb


# Scenario 1
Given /^I am executing the program on the command line$/ do
  @command     = "ruby lib/Battery.rb"
end

Given /^I provide the '\-h' or '\-\-help' switch as a command line argument$/ do
  @arguments     = [ "-h", "--help" ]
  @values      ||= []
end

When /^I execute the program$/ do
  @short       = `#{@command} #{@arguments.first} #{@values.join(" ")}`
  @long        = `#{@command} #{@arguments.last} #{@values.join(" ")}`
end

Then /^I should see in the first line "([^\"]*)"$/ do |arg1|
  raise Exception, "The -h and --help switch need to return a specific first line containing usage" unless( @short.first.chomp.strip == arg1.strip )
end


# Scenario 2
Given /^I provide the '\-d' or '\-\-design' switch as a command line argument \(with \-vr for value and raw\)$/ do
  @arguments      = [ "-d -vr", "--design -vr" ]
  @values       ||= []
end

When /^I execute the program with this design switch$/ do
  @short       = `#{@command} #{@arguments.first} #{@values.join(" ")}`
  @long        = `#{@command} #{@arguments.last} #{@values.join(" ")}`
end

Then /^I should see as a return value an integer number representing the full design capacity of the battery$/ do
 raise Exception, "The return values of -d and --design can't be empty" unless( @short != "" ) and ( @long != "" )
 raise Exception, "The return values of -d and --design should be numerical (they are: #{@short.to_s}, #{@long.to_s})" unless( @short.to_s =~ %r{[0-9]+}i  ) and ( @long.to_s =~ %r{[0-9]+}i )
end

# Scenario 3
Given /^I provide the '\-f' or '\-\-full' switch as a command line argument \(with \-vr for value and raw\)$/ do
  @arguments      = [ "-f -vr", "--full -vr" ]
  @values       ||= []
end

When /^I execute the program with the full capacity switch$/ do
  @short       = `#{@command} #{@arguments.first} #{@values.join(" ")}`
  @long        = `#{@command} #{@arguments.last} #{@values.join(" ")}`
end

Then /^I should see as a return value an integer number representing the full capacity of the battery$/ do
 raise Exception, "The return values of -f and --full can't be empty" unless( @short != "" ) and ( @long != "" )
 raise Exception, "The return values of -f and --full should be numerical (they are: #{@short.to_s}, #{@long.to_s})" unless( @short.to_s =~ %r{[0-9]+}i  ) and ( @long.to_s =~ %r{[0-9]+}i )
end

# Scenario 4
Given /^I provide the '\-n' or '\-\-now' switch as a command line argument \(with \-vr for value and raw\)$/ do
  @arguments      = [ "-n -vr", "--now -vr" ]
  @values       ||= []
end

When /^I execute the program with the current capacity switch$/ do
  @short       = `#{@command} #{@arguments.first} #{@values.join(" ")}`
  @long        = `#{@command} #{@arguments.last} #{@values.join(" ")}`
end

Then /^I should see as a return value an integer number representing the current capacity of the battery$/ do
 raise Exception, "The return values of -n and --now can't be empty" unless( @short != "" ) and ( @long != "" )
 raise Exception, "The return values of -n and --now should be numerical (they are: #{@short.to_s}, #{@long.to_s})" unless( @short.to_s =~ %r{[0-9]+}i  ) and ( @long.to_s =~ %r{[0-9]+}i )
end

# Scenario 5
Given /^I provide the '\-n' or '\-\-now' switch together with '\-p' or '\-\-percent' as a command line argument \(with \-r for raw\)$/ do
  # we will not test the optparser functionality, we just assume it works correct in doing its parsing
  @arguments      = [ "-n", "-p -r" ] 
end

When /^I execute the program with the current capacity switch in percent mode$/ do
  @value          = `#{@command} #{@arguments.first} #{@arguments.last}`.chomp
end

Then /^I should see as a return value an three digit integer number or smaller representing the current capacity of the battery in percentage$/ do
 raise Exception, "The return values of -n and -p can't be empty" unless( @value != "" ) 
 raise Exception, "The return values of -n and -p should be numerical (they are: #{@value.to_s})" unless( @value.to_s =~ %r{[0-9]+}i )
 raise Exception, "The return values of -n and -p should be three digits or less (they are: #{@value.to_s})" unless( @value.to_s.length <= 3 )
end

When /^I provide the '\-f' switch together with '\-p' \(and \-r for raw\)$/ do
  @arguments      = [ "-f", "-p -r" ] 
end

When /^I execute the program with the full capacity switch in percent mode$/ do
  @value          = `#{@command} #{@arguments.first} #{@arguments.last}`.chomp
end

Then /^I should see as a return value of "([^\"]*)"$/ do |arg1|
  raise Exception, "The return values of -f and -p can't be empty" unless( @value != "" ) 
  raise Exception, "The return values of -f and -p should be numerical (they are: #{@value.to_s})" unless( @value.to_s =~ %r{[0-9]+}i )
  raise Exception, "The return values of -f and -p should be three digits (they are: #{@value.to_s})" unless( @value.to_s.length == 3 )
  raise Exception, "The return values of -f and -p should be equal #{arg1.to_s} (they are: #{@value.to_s})" unless( @value.to_i == arg1.to_i )
end

When /^I provide the '\-d' switch together with '\-p' \(and \-r for raw\)$/ do
  @arguments      = [ "-d", "-p -r" ] 
end

When /^I execute the program with the design capacity switch in percent mode$/ do
  @value          = `#{@command} #{@arguments.first} #{@arguments.last}`.chomp
end

Then /^I should see a return value of "([^\"]*)" or greater$/ do |arg1|
  raise Exception, "The return values of -d and -p can't be empty" unless( @value != "" ) 
  raise Exception, "The return values of -d and -p should be numerical (they are: #{@value.to_s})" unless( @value.to_s =~ %r{[0-9]+}i )
  raise Exception, "The return values of -d and -p should be three digits (they are: #{@value.to_s})" unless( @value.to_s.length == 3 )
  raise Exception, "The return values of -d and -p should be equal #{arg1.to_s} or greater (they are: #{@value.to_s})" unless( @value.to_i >= arg1.to_i )
end


# Scenario 6
Given /^I provide the '\-b' and '\-f' switch as a command line argument$/ do
  @arguments      = [ "-b", '-f' ] 
end

When /^I execute the program with the current bar graph switch$/ do
  @value          = `#{@command} #{@arguments.first} #{@arguments.last}`.chomp
end

Then /^I should see a nice bargraph formatting like this$/ do |string|
  raise Exception, "The return value of -b and -f should match test value (''#{string.to_s}'') of a full bar. We got ''#{@value.to_s}''." unless( string == @value )
end


# Scenario 7
Given /^I provide the '\-b', '\-f' and '\-c' switch as a command line argument$/ do
   @arguments      = [ "-b", '-f -c' ]
end

When /^I execute the program with the current bar graph switch in color mode$/ do
  @value          = `#{@command} #{@arguments.first} #{@arguments.last}`.chomp
end

Then /^I should see a nice bargraph formatting like this with colors$/ do |string|
  new_string = string.gsub("e","\e")   # why is this weird hack necessary? What is going on inside ruby here?
  raise Exception, "The return value of -b, -f and -c should match test value (''#{string.to_s}'') of a full green colored bar. We got ''#{@value.to_s}''." unless( new_string == @value )
end



