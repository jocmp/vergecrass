# Vergecrass

_A web scraper for Vergecast episodes missing from RSS_

## Background

Recently I wanted to see what the consensus was of the iPhone 4 when it launched from Engadget. Much like how one can find out how journalists felt about IBM OS/2 on the [Computer Chronicles](https://www.youtube.com/channel/UCkJ6eQKpHZgsZBla4JgKj3A) in its heyday.

Sadly the Engadget Podcast is no longer publicly hosted pre-2010s. All that remains is a series of dead links hopping from the AOL CDN to Yahoo News web pages.

I didn't want to lose the Vergecast the same way. The RSS feed is only live from 2014 until present day but the original episodes and the _This Is My Next_ podcast are still available online.

## The Scraper

Presented is a simple Ruby scraper that takes two hard-coded dates in the `generate_year_months`  method in the `main.rb` and parses out the Vergecast feed from the beginning (April 2011) until the site no longer displayed inline MP3s (circa 2015). I hope this scarper helps springboard some digital hoarding for you too.
