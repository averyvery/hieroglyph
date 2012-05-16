module Hieroglyph

  class NoopSheet
    def initialize(*)
      Hieroglyph.error "ImageMagick not detected - skipping character sheet"
    end
    def add(file)
    end
    def save
    end
  end

end
