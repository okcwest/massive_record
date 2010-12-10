module MassiveRecord
  module ORM
    module AttributeMethods
      module Dirty
        extend ActiveSupport::Concern
        include ActiveModel::Dirty


        def save(*)
          if status = super
            changed_attributes.clear
          end
          status
        end

        def save!(*)
          super.tap do
            changed_attributes.clear
          end
        end

        def reload(*)
          super.tap do
            changed_attributes.clear
          end
        end

        def write_attribute(attr_name, value)
          attr_name = attr_name.to_s

          if will_change_attribute?(attr_name, value)
            if will_change_back_to_original_value?(attr_name, value)
              changed_attributes.delete(attr_name)
            else
              super(attr_name, original_attribute_value(attr_name))
              send("#{attr_name}_will_change!")
            end
          end

          super
        end


        private

        def update(*)
          changes.empty? ? true : super(changes.keys)
        end

        def original_attribute_value(attr_name)
          @original_attribute_values ||= {}

          unless @original_attribute_values.has_key? attr_name
            @original_attribute_values[attr_name] = send(attr_name)
          end

          @original_attribute_values[attr_name]
        end

        def will_change_attribute?(attr_name, value)
          read_attribute(attr_name) != value
        end

        def will_change_back_to_original_value?(attr_name, value)
          original_attribute_value(attr_name) == value
        end
      end
    end
  end
end
