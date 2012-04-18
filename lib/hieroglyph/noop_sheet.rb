module Hieroglyph

  class NoopSheet
    def initialize(*)
      Hieroglyph.log "ImageMagick not detected - skipping character sheet"
    end
    def add(file)
    end
    def save
    end
  end

end
