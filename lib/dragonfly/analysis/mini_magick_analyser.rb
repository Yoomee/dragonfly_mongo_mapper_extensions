require 'mini_magick'

module Dragonfly
  module Analysis
    
    class MiniMagickAnalyser < Base
      
      def width(image)
        mini_magick_image(image)[:width]
      end
      
      def height(image)
        mini_magick_image(image)[:height]
      end
      
      def aspect_ratio(image)
        mini_magick_data = mini_magick_image(image)
        mini_magick_data[:width].to_f / mini_magick_data[:height].to_f
      end
      
      def depth(image)
        mini_magick_image(image)['%z']
      end
      
      def number_of_colours(image)
        mini_magick_image(image)['%k']
      end
      alias number_of_colors number_of_colours

			# FIXME this method should be called format simply, but that seems to cause problems
      def image_format(image)
        mini_magick_image(image)[:format].downcase.to_sym
      end
      
      private
      
      def mini_magick_image(image)
        MiniMagick::Image.from_blob(image.data)
      rescue MiniMagick::MiniMagickError => e
        log.warn("Unable to handle content in #{self.class} - got:\n#{e}")
        throw :unable_to_handle
      end
      
    end
    
  end
end