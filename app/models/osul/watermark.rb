
module Osul
  class Watermark < Hydra::Derivatives::Image

    def create_derivative
      if ::GenericFile.image_mime_types.include? object.mime_type

        format = 'jpg'
        quality = nil
        xfrm = MiniMagick::Image.read(object.content.content) 

        watermark = MiniMagick::Image.open(File.join(Rails.root, 'app','assets','images', 'OSUL_watermark.png'))

        watermark = watermark.resize "#{(xfrm.dimensions.first * 0.6).to_s}x#{(xfrm.dimensions.last * 0.6).to_s}^"
        result = xfrm.composite(watermark) do |c|
          c.dissolve "50"
          c.gravity "Center"
        end
        result.write xfrm.path
        xfrm.format(format)

        MiniMagick::Tool::Convert.new do |convert|
          convert.merge! ["-units", "PixelsPerInch", xfrm.path, "-density", "150", xfrm.path]
        end
      
        stream = StringIO.new
        xfrm.write(stream)
        stream.rewind

        object.low_resolution.content = stream
        object.mime_type = new_mime_type(format)
        object.save   

      end
    end

  end
end


