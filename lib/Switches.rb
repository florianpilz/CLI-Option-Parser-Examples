# Switches

# 20100113, 20100115
# 0.9.8

# Description: Switches provides for a nice wrapper to OptionParser to also act as a store for switches supplied.  

# Todo:
# 1. Clean up #set.  Done as of 0.4.0.  
# 2. Reinstitute some specs.  

# Ideas: 
# 1. Use ! for options with required switches?  Done as of 0.6.0.  (Changed to being for required arguments in 0.9.0 however.)
# 2. Do away with optional arguments entirely.  Since when does anyone want to specify a non-boolean switch and then supply no arguments anyway?...  OK, maybe sometimes, but this is pretty obscure IMO.  OK, bad idea.  These can be used as action oriented sub-commands.  

# Notes: 
# 1. A limitation is the inability to use the switch, "-?", since there is no Ruby method, #?.  
# 2. An additional limitation is that the Switches class cannot have methods which are the same as any OptionParser methods since these will be forwarded to the OptionParser instance, @op.  
# 3. In 0.9.0 there is finally now a clear demarcation between switch arguments and switches themselves being mandatory or optional.  
# 4. It mostly makes sense that the Switches interface methods are bang methods, since it is modifying that switch in place with a required argument, rather than relying upon a default or otherwise set value elsewhere and presumably later than when the switch was set.  

# Dependencies: 
# 1. Standard Ruby Library

# Changes since: 0.8:
# (Renamed this project/class from Options to Switches since there are required switches now and required options don't make sense.)
# 1. /Options/Switches/.  
# 2. /RequiredOptionMissing/RequiredSwitchMissing/.  
# 3. /String#boolean_arg?/String#boolean_switch?/.  
# 4. Other references to options changed to switches.  
# 5. + Switches#required/mandatory/necessary.  
# 6. + Swtiches#optional.  
# 7. + Switches#supplied_switches.  
# 8. + Switches#set_unused_switches_to_nil.  
# 9. ~ self-run section to reflect new interface.  
# 0/1 (Removed ! from switch setting methods and moved those to the Switches interface methods.)
# 10. + Switches#do_set.  
# 11. ~ Switches#set.  
# 12. + Switches#set!.  
# 13. + Switches#required!.  
# 14. - String#required_arg?.  
# 15. ~ Switches#on_args + requires_argument.  
# 1/2 (Added casting to nominated Ruby classes.)
# 16. ~ Switches#on_args + options.  
# 17. + Array#extract_options!.  
# 18. + Switches#allowed.  
# 19. + Switches#allowed!.  
# 20. + Swithces#mandatory.  
# 21. + Switches#necessary.  
# 22. ~ Switches#do_set + ...options.  
# 23. ~ Switches#on_args + ...options[:cast].  
# 24. ~ self-run section to do a simple test of casting.  
# 2/3 (Renaming the library file.)
# 25. /Options.rb/Switches.rb/.  
# 3/4 (+ casting interface methods)
# 26. + CastingInterfaceMethods#integer(!).  
# 27. + CastingInterfaceMethods#float(!).  
# 28. + CastingInterfaceMethods#array(!).  
# 29. + CastingInterfaceMethods#regex(p)(!).  
# 30. + CastingInterfaceMethods#boolean(!).  
# 31. ~ Switches#initialize + include_casting_interface_methods.  
# 32. /String#short_arg?/String#short_switch?/.  
# 33. /String#long_arg?/String#long_switch?/.  
# 34. ~ Switches#on_args - boolean_switch.  
# 4/5 (Added default values for switches.)
# 35. ~ CastingInterfaceMethods to extract any options before pushing a cast option, since it was overwriting for those casting interface methods.  
# 36. ~ Switches#initialize, + @defaults.  
# 37. /Switches#set_unused_switches_to_nil/Switches#set_unused_switches/.  
# 38. ~ Switches#set_unused_switches, so as it handles setting unused switches with a default.  
# 5/6 (Setting of defaults was overriding supplied switch values.)
# 39. ~ Switches#set_unused_switches, to make use of #switch_defaults and #unused_switches.  
# 40. + Switches#switch_defaults, as an interface method since it might be useful for querying at some point?  
# 41. + Switches#unused_switches, also as an interface method since it might also be useful for querying at some point?  
# 42. ~ Switches#on_args, so as to enable alternate hash keys (:type and :class) for type casting.  
# 43. ~ self-run section to reflect the optionalness/optionality(?) of summaries.  
# 6/7 (Some small tidyups and removal of self-run section)
# 44. ~ Switches#on_args, shorter when handling casting arguments.  
# 45. /unused_switches/unset_switches/.  
# 46. ~ Switches#check_required_switches, so that the message is not being assigned until a switch is missing.  
# 47. Removed the self-run section and moved it to ./test/run.rb.  
# 7/8 (Addition of #perform and #perform! methods, as well the #do_action method and changes to #on_args to facilitate #perform* methods.)
# 48. ~ Switches#on_args, so as if a block is supplied which is not returning a String, then it will not be placed into the on_args argument list.  
# 49. + Switches#perform, interface for actions which don't require an argument.  
# 50. + Switches#perform!, interface for actions which do require an argument.  
# 51. + Switches#do_action, executes a block when called by either of #perform or #perform!.  

require 'ostruct'
require 'optparse'

class String
  
  def short_switch?
    self =~ /^.$/ || self =~ /^.\?$/ || self =~ /^.\!$/
  end
  
  def long_switch?
    (self =~ /^..+$/ && !short_switch?) || self =~ /^..+\?$/ || self =~ /^..+!$/
  end
  
  def boolean_switch?
    self =~ /\?$/
  end
  
end

class Array
  
  def extract_options!
    last.is_a?(::Hash) ? pop : {}
  end
  
end

class OptionParser
  
  def soft_parse
    argv = default_argv.dup
    loop do
      begin
        parse(argv)
        return
      rescue OptionParser::InvalidOption
        argv.shift
      end
    end
  end
  
end

module CastingInterfaceMethods
  
  def integer(*attrs, &block)
    attrs << attrs.extract_options!.merge({:cast => Integer})
    set(*attrs, &block)
  end
  
  def integer!(*attrs, &block)
    attrs << attrs.extract_options!.merge({:cast => Integer})
    set!(*attrs, &block)
  end
  
  def float(*attrs, &block)
    attrs << attrs.extract_options!.merge({:cast => Float})
    set(*attrs, &block)
  end
  
  def float!(*attrs, &block)
    attrs << attrs.extract_options!.merge({:cast => Float})
    set!(*attrs, &block)
  end
  
  def array(*attrs, &block)
    attrs << attrs.extract_options!.merge({:cast => Array})
    set(*attrs, &block)
  end
  
  def array!(*attrs, &block)
    attrs << attrs.extract_options!.merge({:cast => Array})
    set!(*attrs, &block)
  end
  
  def regexp(*attrs, &block)
    attrs << attrs.extract_options!.merge({:cast => Regexp})
    set(*attrs, &block)
  end
  alias_method :regex, :regexp
  
  def regexp!(*attrs, &block)
    attrs << attrs.extract_options!.merge({:cast => Regexp})
    set!(*attrs, &block)
  end
  alias_method :regex!, :regexp!
  
  def boolean(*attrs, &block)
    attrs.collect!{|a| a.to_s =~ /\?$/ ? a : (a.to_s + '?').to_sym}
    set(*attrs, &block)
  end
  
end

class RequiredSwitchMissing < RuntimeError; end

class Switches
  
  def initialize(include_casting_interface_methods = true)
    self.class.send(:include, CastingInterfaceMethods) if include_casting_interface_methods
    @settings = OpenStruct.new
    @op = OptionParser.new
    @required_switches = []
    @all_switches = []
    @defaults = {}
    if block_given?
      yield self
      parse!
    end
  end
  
  def set(*attrs, &block)
    do_set(false, *attrs, &block)
  end
  alias_method :optional, :set
  alias_method :allowed, :set
  
  def set!(*attrs, &block)
    do_set(true, *attrs, &block)
  end
  alias_method :optional!, :set!
  alias_method :allowed!, :set!
  
  def required(*attrs, &block)
    @required_switches = @required_switches + attrs.collect{|a| a.to_s}
    set(*attrs, &block)
  end
  alias_method :mandatory, :required
  alias_method :necessary, :required
  alias_method :compulsory, :required
  
  def required!(*attrs, &block)
    @required_switches = @required_switches + attrs.collect{|a| a.to_s}
    set!(*attrs, &block)
  end
  alias_method :mandatory!, :required!
  alias_method :necessary!, :required!
  alias_method :compulsory!, :required!
  
  def perform(*attrs, &block)
    do_action(false, *attrs, &block)
  end
  
  def perform!(*attrs, &block)
    do_action(true, *attrs, &block)
  end
  
  def parse!
    @op.parse!
    check_required_switches
    set_unset_switches
  end
  
  def supplied_switches
    @settings.instance_variable_get(:@table).keys.collect{|s| s.to_s}
  end
  
  def switch_defaults
    @defaults.keys.collect{|default| default.to_s}
  end
  
  def unset_switches
    @all_switches - supplied_switches - switch_defaults
  end
  
  private
  
  def do_set(requires_argument, *attrs, &block)
    options = attrs.extract_options!
    @all_switches = @all_switches + attrs.collect{|a| a.to_s}
    @op.on(*on_args(requires_argument, options, *attrs, &block)) do |o|
      attrs.each do |attr|
        @settings.send(attr.to_s + '=', o)
      end
    end
  end
  
  def do_action(requires_argument, *attrs, &block)
    options = attrs.extract_options!
    @all_switches = @all_switches + attrs.collect{|a| a.to_s}
    @op.on(*on_args(requires_argument, options, *attrs)) do |o|
      yield o if block
    end
  end
  
  def method_missing(method_name, *args, &block)
    if (@op.methods - Switches.instance_methods).include?(method_name.to_s)
      @op.send(method_name.to_s, *args, &block)
    else
      @settings.send(method_name.to_s, *args, &block)
    end
  end
  
  def on_args(requires_argument, options, *attrs, &block)
    on_args = []
    attrs.collect{|e| e.to_s}.each do |attr|
      @defaults[attr] = options[:default] if options[:default]
      on_args << "-#{attr.long_switch? ? '-' : ''}#{attr.to_s.delete('?')}"
    end
    if requires_argument
      on_args << (on_args.pop + ' REQUIRED_ARGUMENT')
    elsif !!attrs.last.to_s.boolean_switch?
      on_args << (on_args.pop)
    else
      on_args << (on_args.pop + ' [OPTIONAL_ARGUMENT]')
    end
    on_args << (options[:cast] || options[:type] || options[:class]) if (options[:cast] || options[:type] || options[:class])
    if block
      yield_result = yield
      on_args << yield_result if yield_result.class == String
    end
    on_args
  end
  
  def check_required_switches
    @required_switches.each do |required_switch|
      unless supplied_switches.include?(required_switch)
        message = "required switch, -#{required_switch.long_switch? ? '-' : ''}#{required_switch.to_s.delete('?')}, is missing"
        raise RequiredSwitchMissing, message
      end
    end
  end
  
  def set_unset_switches
    unset_switches.each{|switch| @settings.send(switch + '=', nil)}
    switch_defaults.each{|switch| @settings.send(switch + '=', @defaults[switch]) if @settings.send(switch).nil?}
  end
  
end
