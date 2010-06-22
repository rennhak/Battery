#!/usr/bin/ruby
#

# = Standard Libraries
require 'optparse'

# = Battery is the main class which handles commandline interface and other central tasks
class Battery # {{{

  def initialize options, baseDir = "/sys/class/power_supply/BAT0", design = "energy_full_design", full = "energy_full", now = "energy_now"
    @options = options

    %w[design full now].each do |state|
      eval( "@#{state.to_s}Path = \"#{baseDir}/#{eval( state ).to_s}\"" )     # this creates e.g. @designPath,..
      eval( "@#{state.to_s}     = File.open( eval(\"@\"+state+\"Path\").to_s ).readlines.to_s.chomp" )
      self.class.class_eval %{ def #{state.to_s}; @state; end }
    end

    show_design_capacity      if( @options[ :design ] )
    show_full_capacity        if( @options[ :full ] )
    show_now_capacity         if( @options[ :now ] )
  end # of initialize }}}

  # = The show_design_capacity function takes care of showing the design capacity state
  # @param value
  # @returns 
  # @helpers formatting
  def show_design_capacity value = @design # {{{
    formatting( "Battery (Design)", value ).each { |line| puts line }
  end # of def show_design_capacity }}}

  # = The show_full_capacity function takes care of showing the full capacity state
  # @param value
  # @returns
  # @helpers formatting
  def show_full_capacity value = @full # {{{
    formatting( "Battery (Full)", value ).each { |line| puts line }
  end # of def show_full_capacity }}}

  # = The show_now_capacity function takes care of showing the current capacity state
  # @param value
  # @returns
  # @helpers formatting
  def show_now_capacity value = @now # {{{
    formatting( "Battery (Now)", value ).each { |line| puts line }
  end # of def show_now_capacity }}}

  # = The formatting helper function takes care of returning properly formatted strings for the show_{full,design,now}_capacity functions
  # @param text String, text to display in the formatting
  # @param value Integer, value which represents the battery value
  # @returns String, with the formatted content which various show_* functions display.
  # @helpers percentage_of, generate_bar
  def formatting text, value, color = false # {{{
    # == Possibilities
    # @options[ :bar ]      ::= { true, false }
    # @options[ :percent ]  ::= { true, false }

    # Push arrays onto stack for later sprintf if options match
    stack       = Array.new
    percentage  = percentage_of( value )

    if( @options[:raw] )
      stack << [ "%s", text                                                             ]  if( @options[ :text     ] )
      stack << [ "%s", value                                                            ]  if( @options[ :value    ] )
      stack << [ "%s", generate_bar( percentage )                                       ]  if( @options[ :bar      ] )
      stack << [ "%s", percentage                                                       ]  if( @options[ :percent  ] )
    else
      if( @options[:color] )
        color_end                   = "\e[0m"
        green, yellow, red, blink   = "\e[1;32m", "\e[1;33m", "\e[1;31m", "\e[5;31m"
        high, medium, low           = 70, 35, 12

        color = green   if( percentage >= high )
        color = yellow  if( (percentage < high) and (percentage >= medium) )
        color = red     if( (percentage < medium) && ( percentage >= low ) )
        color = blink   if( percentage < low )

        stack << [ "[ %-25s ]", text                                                    ]  if( @options[ :text     ] )
        stack << [ "[ %10s ]", value                                                    ]  if( @options[ :value    ] )
        stack << [ "[ %-100s ]", color + generate_bar( percentage ) + color_end         ]  if( @options[ :bar      ] )
        stack << [ "[ %3s Percent ]", percentage                                        ]  if( @options[ :percent  ] )
      else
        stack << [ "[ %-25s ]", text                                                    ]  if( @options[ :text     ] )
        stack << [ "[ %10s ]", value                                                    ]  if( @options[ :value    ] )
        stack << [ "[ %-100s ]", generate_bar( percentage )                             ]  if( @options[ :bar      ] )
        stack << [ "[ %3s Percent ]", percentage                                        ]  if( @options[ :percent  ] )
      end # of if( @option[:color] )
    end # of if( @options[:raw] )

    format  = stack.transpose.first.join( " " )
    values  = stack.transpose.last
    sprintf( format, *values )
  end # of def formatting }}}


  # = The percentage_of helper funcction gives back an percentage according to a given scale value
  # @param input Integer value which represents e.g. a current battery charge
  # @param scale_value Integer value which represents e.g. a full battery charge or the design capacity
  # @returns Percentage value calculated by (input.to_f/(scale_value.to_f/100.0)) with integer precision
  # @helps formatting
  def percentage_of input, scale_value = @full # {{{
    onePercent  = scale_value.to_f / 100.0
    ( input.to_f / onePercent ).to_i
  end # of def length }}}

  # = The generate_bar helper function generates a bar "|" of a desired length
  # @param length Integer which represents the desired length of the string to be generated
  # @param char String which containts the character(s) used to make up the bar content, e.g. "|"
  # @returns String with the desired length consisting of chara
  # @helps formatting
  def generate_bar length, char = "|" # {{{
    char * length.to_i
  end # of def bar }}}

end # of class Battery }}}


# = Direct invocation
if __FILE__ == $0

  options = {}
  OptionParser.new do |opts|
    opts.banner = "Usage: Battery.rb [options]"

    opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
      options[:verbose]   = v
    end

    opts.on("-d", "--design", "Show numerical value of the design capacity for the battery") do |d|
      options[:design]    = d
    end

    opts.on("-f", "--full", "Show numerical value of the full capacity for the battery") do |f|
      options[:full]      = f
    end

    opts.on("-n", "--now", "Show numerical value of the current capacity for the battery") do |n|
      options[:now]       = n
    end

    opts.on("-p", "--percent", "Show all values in percent") do |p|
      options[:percent]   = p
    end

    opts.on("-b", "--bar", "Show a bargraph of the current battery situation") do |b|
      options[:bar]   = b
    end

    opts.on("-t", "--text", "Show a descriptive text with the values") do |t|
      options[:text]   = t
    end

    opts.on("-v", "--value", "Show the charge value") do |v|
      options[:value]   = v
    end

    opts.on("-r", "--raw", "Show the value without formatting (only for capacity OR percent per time)") do |r|
      options[:raw]   = r
    end

    opts.on("-c", "--color", "Colorize all output") do |c|
      options[:color]   = c
    end
  end.parse!

  if( options.empty? )
    raise ArgumentError, "Please try '-h' or '--help' to view all possible options"
  else
    raise ArgumentError, "How would you like that formatted ? For instance minumum version would be, e.g. '-nv' or '-nvr' for raw" unless( options[:value] or options[:bar] or options[:percent] )
  end

  battery = Battery.new( options )


end # of if __FILE__ == $0
