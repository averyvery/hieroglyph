# Hieroglyph

Convert a folder full of icons into an icon font, ready for use on the web.

## Installation

	gem install hieroglyph

## Usage

Create a directory full of SVG glyphs, and run:

	hieroglyph FontName path/to/glyphs destination/path

All arguments are optional. If you leave off any of them, the defaults used will be:

- 'MyFont' for fontname
- 'glyphs' for glyph path
- The current directory for destination path

## Making Glyphs

- In a vector editor (Illustrator, Inkscape), create a 1000pt x 1000pt canvas
- Draw your icon as a single compound path
- Center it horizontally
- Vertically, fit it between ~y288 and ~y1025
	- Tip: Use Illustrator's Transform palette to set the icon to 737pt high, with a y of 656 and x of 500
- Save it as a-[iconname].svg in your glyphs folder, 'a' being the letter you want to map the glyph to. [iconname] can be anything, it's just to help you remember which icon you used.

## Todo

- Use nokogiri for parsing XML instead of...you know....regex.
- Parse from EPS or SVG.
- Include an example SVG glyph.
- Use private use unicode symbols for accessibility reasons:
	- https://twitter.com/#!/danscotton/statuses/180321697449263106
	- http://en.wikipedia.org/wiki/Private_Use_(Unicode)
