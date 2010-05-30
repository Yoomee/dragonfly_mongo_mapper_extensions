module Dragonfly
  module MongoMapperExtensions
    module ClassMethods

      include Validations

      def register_dragonfly_app(accessor_prefix, app)
        eigenclass = respond_to?(:metaclass) ? metaclass : singleton_class # Because rails changed the name from metaclass -> singleton_class
        eigenclass.class_eval do
    
          # Defines e.g. 'image_accessor' for any activerecord class body
          define_method "#{accessor_prefix}_accessor" do |attribute|
      
            # Prior to activerecord 3, adding before callbacks more than once does add it more than once
            before_save :save_attachments unless respond_to?(:before_save_callback_chain) && before_save_callback_chain.find(:save_attachments)
            before_destroy :destroy_attachments unless respond_to?(:before_destroy_callback_chain) && before_destroy_callback_chain.find(:destroy_attachments)
      
            # Register the new attribute
            dragonfly_apps_for_attributes[attribute] = app
            
            # Define the setter for the attribute
            define_method "#{attribute}=" do |value|
              attachments[attribute].assign(value)
            end
      
            # Define the getter for the attribute
            define_method attribute do
              attachments[attribute].to_value
            end

						# MongoMapper specific
						key "#{attribute}_uid"
      
          end
    
        end
        app
      end
      
      def dragonfly_apps_for_attributes
        @dragonfly_apps_for_attributes ||= begin
          parent_class = ancestors.select{|a| a.is_a?(Class) }[1]
          parent_class.respond_to?(:dragonfly_apps_for_attributes) ? parent_class.dragonfly_apps_for_attributes.dup : {}
        end
      end
      
    end
  end
end