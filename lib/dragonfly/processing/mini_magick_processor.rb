module Dragonfly
  module Processing
    class MiniMagickProcessor < Base
      
      # Processing methods
      
      def resize(temp_object, opts={})
        rmagick_image(temp_object).resize( opts[:geometry] ).to_blob
      end
      
      private
      
      def rmagick_image(temp_object)
        MiniMagick::Image.from_blob(temp_object.data)
      rescue MiniMagick::MiniMagickError => e
        log.warn("Unable to handle content in #{self.class} - got:\n#{e}")
        throw :unable_to_handle
      end

    end
  end
end