# Hieroglyph 0.1.2

Icon fonts are a great way to put sharp, highly-malleable icons onto your website using @font-face. [Chris Coyier thinks they're a good idea](http://css-tricks.com/using-fonts-for-icons/), and you should too.

Hieroglyph lets you turn a directory of SVG icons into an SVG font, all simple-like.
To produce the remaining web filetypes (eot, ttf, woff) run the font file through [Fontsquirrel's generator](http://www.fontsquirrel.com/fontface/generator).

If ImageMagick is installed (optional), hieroglyph will also draw a character sheet PNG for you.

## Installation

To install the current version from RubyGems:

	gem install hieroglyph

To install the most recent version, from GitHub:

	git clone https://github.com/averyvery/hieroglyph.git && \
	cd hieroglyph && \
	gem build hieroglyph.gemspec && \
	gem install hieroglyph

## Usage

Create a directory full of SVG glyphs, and run:

	hieroglyph -n FontName -g path/to/glyphs -o destination/path

Arguments:

	-n, --name NAME               name of the font you want generated (defaults to MyFont)
	-o, --output OUTPUT_FOLDER    where to output the generated font (defaults to current folder)
	-g, --glyphs GLYPH_FOLDER     where to find glyphs to generate from (defaults to "glyphs")
	-e, --example                 output set of example glyphs
	-v, --version                 display Hieroglyph version
	-h, --help                    display this info

Using the -e or -v arguments will NOT output a font.

## Making Glyphs

- In a vector editor (Illustrator, Inkscape), create a 1000pt x 1000pt canvas
- Draw your icon as a single compound path
- Center it horizontally
- Vertically, fit it between ~y250 and ~y1000 (the bottom of the canvas)
- Save it as a-[iconname].svg in your glyphs folder, 'a' being the letter you want to map the glyph to. [iconname] can be anything, it's just to help you remember which icon you used.

## Testing

	rake test

## Known Issues

- If ImageMagick is installed without Ghostscript fonts, the character sheet process will throw an error. The font is still generated correctly, though.

## Thanks

- [Chris Coyier](http://chriscoyier.net/), for bringing attention to the [icon font technique.](http://css-tricks.com/using-fonts-for-icons/)
- [Stephen Wyatt Bush](http://stephenwyattbush.com/), for his in-depth [tutorial.](http://blog.stephenwyattbush.com/2012/02/01/making-an-icon-font)
- [Jeremy Holland](http://www.jeremypholland.com/), for the [Savage SVG parsing gem.](https://github.com/awebneck/savage)
- [Inkscape contributors](https://launchpad.net/inkscape/+topcontributors), who provided the original SVG font tool I used a lot on this project.

## Todo

- Tests
- Clean up Glyph class. It's crazy!
- Parse from EPS _or_ SVG. Not sure if this is doable with available open-source technology.
- Use private use unicode symbols, for accessibility reasons:
	- http://twitter.com/#!/danscotton/statuses/180321697449263106
	- http://en.wikipedia.org/wiki/Private_Use_(Unicode)
