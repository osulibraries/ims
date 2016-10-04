module FedoraObjectAssociations
  extend ActiveSupport::Concern

  included do
    if defined? after_initialize
      after_initialize do
        init_fedora_association_cache
      end
    end
  end

  def initialize(*args)
    super
    init_fedora_association_cache
  end

  module ClassMethods
    def belongs_to_fedora(name, opts={})
      opts = {
        foreign_key: "#{name.to_s}_id",
        class_name: name.to_s.classify
      }.merge(opts)

      fedora_class = opts[:class_name].constantize

      define_method(name) do
        unless fedora_association_cached?(name)
          fedora_object = find_associated_fedora_object(fedora_class, opts[:foreign_key])
          set_cached_fedora_association(name, fedora_object)
        end

        get_cached_fedora_association(name)
      end

      define_method(name.to_s + '=') do |obj|
        raise AssociationTypeMismatch, "#{obj.class} is not a #{fedora_class}!" unless obj.nil? or obj.is_a? fedora_class
        self.send("#{opts[:foreign_key]}=", obj.try(:id))
        remove_cached_fedora_association(name)
        self.send(name)
      end
    end
  end


  private

    def init_fedora_association_cache
      unless defined? @fedora_association_cache
        @fedora_association_cache = {}
      end
    end

    def fedora_association_cached?(name)
      @fedora_association_cache.key?(name)
    end

    def get_cached_fedora_association(name)
      @fedora_association_cache[name]
    end

    def set_cached_fedora_association(name, obj)
      @fedora_association_cache[name] = obj
    end

    def remove_cached_fedora_association(name)
      if fedora_association_cached? name
        @fedora_association_cache.delete name
      end
    end

    def find_associated_fedora_object(klass, key)
      if self.send(key).present?
        klass.find(self.send(key))
      end
    end


  class AssociationTypeMismatch < StandardError
  end

end
