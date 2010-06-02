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

  def show_design_capacity
    value = @design
    value = ( @design.to_f / ( @full.to_f / 100.0 ) ).to_i     if @options[ :percent ]
    print value
  end

  def show_full_capacity
    value = @full
    value = ( @full.to_f / ( @full.to_f / 100.0 ) ).to_i     if @options[ :percent ]
    print value
  end

  def show_now_capacity
    value = @now
    value = ( @now.to_f / ( @full.to_f / 100.0 ) ).to_i     if @options[ :percent ]
    print value
  end
end # of class Battery }}}


# = Direct invocation
if __FILE__ == $0

  options = {}
  OptionParser.new do |opts|
    opts.banner = "Usage: Battery.rb [options]"

    opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
      options[:verbose] = v
    end

    opts.on("-d", "--design", "Show numerical value of the design capacity for the battery") do |d|
      options[:design] = d
    end

    opts.on("-f", "--full", "Show numerical value of the full capacity for the battery") do |f|
      options[:full] = f
    end

    opts.on("-n", "--now", "Show numerical value of the current capacity for the battery") do |n|
      options[:now] = n
    end

    opts.on("-p", "--percent", "Show all values in percent") do |p|
      options[:percent] = p
    end
  end.parse!

  battery = Battery.new( options )


end # of if __FILE__ == $0
