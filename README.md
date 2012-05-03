# Hieroglyph 0.1.2

Icon fonts are a great way to put sharp, highly-malleable icons onto your website using @font-face. [Chris Coyier thinks they're a good idea](http://css-tricks.com/using-fonts-for-icons/), and you should too.

Hieroglyph lets you turn a directory of SVG icons into an SVG font, all simple-like.
To produce the remaining web filetypes (eot, ttf, woff) run the font file through [Fontsquirrel's generator](http://www.fontsquirrel.com/fontface/generator).

If ImageMagick is installed (optional), hieroglyph will also draw a character sheet PNG for you.

## Installation

To install the current version from RubyGems:

	gem install hieroglyph

To install the most recent version, from GitHub:

	git clone git@github.com:averyvery/hieroglyph.git && \
	cd hieroglyph && \
	gem build hieroglyph.gemspec && \
	gem install hieroglyph

To do a quick test run, just generate some example glyphs and create a MyFont font like so:

	hieroglyph -e && hieroglyph

## Usage

Create a directory full of SVG glyphs, and run:

	hieroglyph -n FontName -g path/to/glyphs -o destination/path

Font creation arguments:

	-n, --name NAME               name of the font you want generated (defaults to MyFont)
	-o, --output OUTPUT_FOLDER    where to output the generated font (defaults to current folder)
	-g, --glyphs GLYPH_FOLDER     where to find glyphs to generate from (defaults to "glyphs")

Misc (using these arguments will not produce a font:

	-e, --example                 creats set of example glyphs, including two "bad" SVGs for reference
	-v, --version                 display Hieroglyph version
	-h, --help                    display all commands

## Converting

Because hieroglyph only generates SVGs, you'll need to convert the resulting file to other formats yourself. [The Font Squirrel Generator](http://www.fontsquirrel.com/fontface/generator) is usually the best tool for this, but as of May 2012 it was having trouble uploading/reading SVGs. If you run into this problem, try converting your font to a TTF first with [Free Font Converter](http://www.freefontconverter.com).

## Making Glyphs

- In a vector editor (Illustrator, Inkscape), create a 1000pt x 1000pt canvas
- Draw/merge your icon into a single compound path (this is important!)
- Center it horizontally
- Vertically, fit it between cap height of 250pt the baseline of 1000pt
- Save as **a-[iconname].svg** in your glyphs folder, 'a' being the letter you want to map to. You can also use something like **&<wbr>#xf8ff;-[iconname].svg** to map to a unicode character.

## Private Unicode Symbols

Mapping your icons to private-use unicode characters is an extra measure to prevent screenreaders from seeing them. You can see an example of this by running <code>hieroglyph -e</code>, it just involves naming your glyph with a unicode characted before the dash.

The basic range of valid names runs from &<wbr>#xe000; to &<wbr>#xf8ff;.

To create a full font using FontSquirrel, you'll need to use Expert mode and subset your font with the unicode characters.

<img src="https://raw.github.com/averyvery/hieroglyph/master/lib/hieroglyph/assets/fontsquirrel-subsetting.jpg" />

Read more: [Dan Scotton's tweet](http://twitter.com/#!/danscotton/statuses/180321697449263106), <a href="http://en.wikipedia.org/wiki/Private_Use_(Unicode)">Wikipedia</a>

## Known Issues

- If ImageMagick is installed without Ghostscript fonts, the character sheet process will throw an error. The font is still generated correctly, though.

## Contribute

If you want to help out, great! As an inexperienced dev, I'd appreciate any help I can get &mdash; but I would <em>most</em> appreciate it in the form of suggestions, education, and well-justified changes. If you have a specific bug or feature you'd like to pull request for, please [let me know about it](https://github.com/averyvery/hieroglyph/issues/new) so we're on the same page.

## Thanks

- [Chris Coyier](http://chriscoyier.net/), for bringing attention to the [icon font technique.](http://css-tricks.com/using-fonts-for-icons/)
- [Stephen Wyatt Bush](http://stephenwyattbush.com/), for his in-depth [tutorial.](http://blog.stephenwyattbush.com/2012/02/01/making-an-icon-font)
- [Jeremy Holland](http://www.jeremypholland.com/), for the [Savage SVG parsing gem.](https://github.com/awebneck/savage)
- [Inkscape contributors](https://launchpad.net/inkscape/+topcontributors), who provided the original SVG font tool I used a lot on this project.
