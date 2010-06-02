#!/usr/bin/ruby

######
#
# (c) 2010, Bjoern Rennhak
# This script reads /sys/class/power_supply/BAT0/energy_* and prints in nicely on the screen.
#
##########


class Battery
  def initialize baseDir = "/sys/class/power_supply/BAT0", design = "energy_full_design", full = "energy_full", now = "energy_now"
    %w[design full now].each do |state| 
      eval( "@#{state.to_s}Path = \"#{baseDir}/#{eval( state ).to_s}\"" )     # this creates e.g. @designPath,..
      eval( "@#{state.to_s}     = File.open( eval(\"@\"+state+\"Path\").to_s ).readlines.to_s.chomp" )
      learn( state.to_s, eval( "@"+state ) )
    end
  end # of initialize

  # Learn stuff on the fly
  def learn method, code
      code = code.to_s.gsub( /"/, "" )
      eval <<-EOS
          class << self
              def #{method}; "#{code}"; end
          end
      EOS
  end # of def learn

  # Gives back an percentage according to design vs full/now
  def length input, design = @design.to_i
    # design = 100% 
    onePercent  = design / 100
    result      = input.to_i / onePercent
    result
  end # of def length

  # Generates a bar "|" of a desired length
  def bar length, char = "|"
    char * length.to_i
  end # of def bar

  def color percentage, text,  good = 70, medium = 35, blink = 12

    result = "\e[1;32m #{text.to_s} \e[0m" if( percentage >= good )                                   # green
    result = "\e[1;33m #{text.to_s} \e[0m" if( (percentage < good) and (percentage >= medium) )       # yellow
    result = "\e[1;31m #{text.to_s} \e[0m" if( (percentage < medium) && ( percentage >= blink) )      # red
    result = "\e[5;32m #{text.to_s} \e[0m" if( percentage < blink )                                   # blink

    result
  end

  # Simple print
  def to_s
    ld, lf, ln = length( @design ), length( @full ), length( @now )
    printf( "%-25s | %10s | %-115s | %3s Percent\n",  "Battery Full (Design)",  @design.to_s, color( ld, bar( ld ) ), ld  ) 
    printf( "%-25s | %10s | %-115s | %3s Percent\n",  "Battery Full",        @full.to_s, color( ld, bar( lf ) ),  lf  ) 
    printf( "%-25s | %10s | %-115s | %3s Percent\n",  "Battery Now",         @now.to_s, color( ln, bar( ln ) ), ln  ) 
  end


end # of class Battery


if __FILE__ == $0

  battery = Battery.new
  battery.to_s

end # of if __FILE__ == $0
