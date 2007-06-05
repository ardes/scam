# extended into ActiveRecord, adds macros to associate any model with scam(s)
module Scammable
  def self.extended(base)
    base.class_eval do
      class_inheritable_writer :scam_class_name
    end
  end

  def has_scam(*names)
    include InstanceMethods unless included_modules.include? Scammable::InstanceMethods
    options = names.last.is_a?(Hash) ? names.pop : {}
    names = [:scam] if names.size == 0
    names.each {|name| add_scam(name.to_sym, options)}
  end

  alias_method :has_scams, :has_scam
  
  def scam_class_name
    read_inheritable_attribute(:scam_class_name) || write_inheritable_attribute(:scam_class_name, 'Scam')
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
      raise RuntimeError, "Scam #{name} is already declared" if scam_names.include? name
      scam_names << name
      has_one name, :as => :scammable, :class_name => (options[:class_name] || scam_class_name), :conditions => {:name => name}
    end
  end
end
