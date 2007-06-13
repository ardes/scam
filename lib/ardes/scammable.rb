# extended into ActiveRecord, adds macros to associate any model with scam(s)
module Scammable
  # the default scam class for all ActiveRecords (can be overridden on a per class basis)
  mattr_accessor :scam_class_name
  
  self.scam_class_name = 'Scam'
  
  def has_scam(*names)
    include InstanceMethods unless included_modules.include? Scammable::InstanceMethods
    options = names.last.is_a?(Hash) ? names.pop : {}
    names = [:scam] if names.size == 0
    names.each {|name| add_scam(name.to_sym, options)}
  end

  alias_method :has_scams, :has_scam
  
  # set the default scam class for this AciveRecord and its descendents
  def scam_class_name=(class_name)
    write_inheritable_attribute(:scam_class_name, class_name)
  end
  
  # the default scam class for this AciveRecord and its descendents
  def scam_class_name
    read_inheritable_attribute(:scam_class_name) || write_inheritable_attribute(:scam_class_name, Scammable.scam_class_name)
  end
  
  module InstanceMethods
    def self.included(base)
      base.class_eval do
        extend ClassMethods
      end
    end
  end

  module ClassMethods
    def scam_names
      read_inheritable_attribute(:scam_names) || write_inheritable_attribute(:scam_names, [])
    end
    
  protected
    def add_scam(name, options = {})
      raise RuntimeError, "Scam #{name} is already declared in #{self.name}" if scam_names.include? name
      scam_names << name
      scam_class_name = options.delete(:class_name) || self.scam_class_name
      has_one name, options.reverse_merge(:as => :scammable, :class_name => scam_class_name, :conditions => ["#{Scam.table_name}.name = ?", name])
      
      class_eval <<-end_eval, __FILE__, __LINE__
        def #{name}_with_build(*args)
          #{name}_without_build(*args) || build_#{name}(:name => :#{name})
        end
        alias_method_chain :#{name}, :build
        
        def #{name}_with_delegation=(arg)
          arg.is_a?(#{scam_class_name}) ? self.#{name}_without_delegation = arg : self.#{name}.content = arg
        end
        alias_method_chain :#{name}=, :delegation
      end_eval
    end
  end
end
