---
layout   : page
title    : "octoburn"
date     : 2012-09-19 23:11
comments : true
sharing  : true
---

[Octoburn](https://github.com/hilary/octoburn) is a blogging engine
for [Jekyll](https://github.com/mojombo/jekyll) pages. It is a close
descendant of
[Octopress](https://github.com/imathis/octopress/tree/2.1) (hence the
name). I originally thought I would write an Octopress theme, however
as I got deeper into the Octopress code I realized that I had
fundamentally different priorities. I am less concerned with providing
a generalized blogging platform for coders and more concerned with
information design. Thus Octoburn only supports respectful social
network widgets but uses the HTML5 microdata standard.

At the moment, Octoburn is still compatible with (and makes use of)
many of the Octopress plugins, some of its Javascript and much of its
build system. I think Octopress is terrific and would very much like to
continue to leverage its facilities.

So what's different?

## leveraging Compass

Octoburn uses a rich set of Compass libraries. Essentially, whenever
I could use a Compass library to do what I wanted to do, I did so:

* [Susy](http://susy.oddbird.net/) for responsive layout. While Susy
  can present something of an initial learning curve, the results are
  worth it. Susy grids encapsulate much of the grid calculations
  without tying a designer down.

* [Vertical Rhythm](http://compass-style.org/reference/compass/typography/vertical_rhythm/)
  for, well, vertical rhythm (the way text flows down a 'page').

* a host of smaller libraries, for example, [Horizontal List](http://compass-style.org/reference/compass/typography/lists/horizontal_list/) and [float](http://compass-style.org/reference/compass/utilities/general/float/).

Why use Compass? The single largest benefit is that the libraries
encapsulate cross-browser issues, and continue to do so as browsers
evolve. Life is too short to reinvent the wheel, or, in this case get
run over by it!

Comprehensive libraries such as Susy and Vertical Rhythm make it possible
to achieve in days what used to take a week. They also make implementing
changes fun as opposed to mildly terrifying.

## [microdata](http://schema.org/)

Octoburn's markup uses the relevant microdata schema. Microdata is
critical to having your information correctly indexed by the major
search engines. A new set of extremely promising schemas for technical
materials is in review. I plan on trying some of them out.

Encoding markup with microdata has a secondary benefit. Semantic HTML5
is challenging. Many elements can legitimately be marked up in
multiple ways depending on context. I often find that ambiguous
elements resolve themselves as I work through a schema.

## convention over configuration

I spend a lot of my time in Rails; one of the strengths of the Rails
architecture is how easy it is to find
things. [Sass](http://sass-lang.com/)'s `@import` facility made it
possible for me to create a similar architecture in Octoburn.

Consider, for example, the follow menu at the top of each page:

* the template is `_includes/menus/follow_menu.html`
* the sass is `menus/_follow_menu.scss`

(There's more to the Sass import design, but a proper treatment would
be a full post.) 

## what's next?

While I have lots of plans for Octoburn, my next step is to turn it
into a gem. Hi, my name is Hilary, and I am an agile addict. I need
my bdd toolset!