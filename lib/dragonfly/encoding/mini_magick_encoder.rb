module Dragonfly
  module Encoding

    class MiniMagickEncoder < Base

      include Configurable

      configurable_attr :supported_formats, [
        :ai,
        :bmp,
        :eps,
        :gif,
        :gif87,
        :ico,
        :j2c,
        :jp2,
        :jpeg,
        :jpg,
        :pbm,
        :pcd,
        :pct,
        :pcx,
        :pdf,
        :pict,
        :pjpeg,
        :png,
        :png24,
        :png32,
        :png8,
        :pnm,
        :ppm,
        :ps,
        :psd,
        :ras,
        :tga,
        :tiff,
        :wbmp,
        :xbm,
        :xpm,
        :xwd
      ]

      def encode(image, format, encoding={})
        format = format.to_s.downcase
        throw :unable_to_handle unless supported_formats.include?(format.to_sym)
        encoded_image = mini_magick_image(image)
        if encoded_image.format.downcase == format
          image # do nothing
        else
          encoded_image.format = format
          encoded_image.to_blob
        end
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
