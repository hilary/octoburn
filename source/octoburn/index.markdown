---
layout   : page
title    : "octoburn"
date     : 2012-09-19 23:11
comments : true
sharing  : true
---

[Octoburn](https://github.com/hilary/octoburn) is a blogging engine
for [Jekyll](https://github.com/mojombo/jekyll) pages based on
[Octopress](https://github.com/imathis/octopress/tree/2.1).

## contents {#toc}

<ul class="toc">
 <li><a href="#leveraging_compass">leveraging Compass</a>
  <ul><li><a href="#susy">Susy for responsive layout</a></li>
  <li><a href="#vertical_rhythm">Vertical Rhythm for readability</a></li></ul>
 </li>
 <li><a href="#microdata">microdata</a></li>
 <li><a href="#convention">convention over configuration</a>
  <ul><li><a href="#waldo">where's waldo?</a></li>
  <li><a href="#tags">tags are not categories</a></li></ul>
 </li>
 <li><a href="#next">what's next?</a></li>
</ul>

## <a name="leveraging_compass"></a>leveraging Compass

### <a name="susy"></a>[Susy](http://susy.oddbird.net/) for responsive layout. 

While doing a Susy design from scratch can present something of an
initial learning curve, customizing an existing design is a joy. Want
4 asides instead of 3 in your default layout? Allocate columns to each
aside in `sass/asides/_default_layout.scss` and regenerate. You're done.

### <a name="vertical_rhythm"></a>[Vertical Rhythm](http://compass-style.org/reference/compass/typography/vertical_rhythm/) for readability

Vertical rhythm refers to the way text flows down a page. The core of
Compass's Vertical Rhythm library is the ability to adjust both
font-size and line-height with a single call. The `establish-baseline`
mixin is integrated with other Compass libraries such as Susy.

### and many more

Octoburn uses a host of smaller Compass libraries as well. Two
examples are [Horizontal
List](http://compass-style.org/reference/compass/typography/lists/horizontal_list/)
and
[float](http://compass-style.org/reference/compass/utilities/general/float/).

Why use Compass? The single largest benefit is that the libraries
encapsulate cross-browser issues, and continue to do so as browsers
evolve. Life is too short to reinvent the wheel, or, in this case get
run over by it!

Comprehensive libraries such as Susy and Vertical Rhythm make it possible
to achieve in days what used to take a week. They also make implementing
changes fun as opposed to mildly terrifying.

## <a name="microdata"></a>[microdata](http://schema.org/)

Octoburn's markup uses relevant microdata schemas. A set of microdata liquid
filters is included as a plugin for easy template customization.

Microdata is critical to having your information correctly indexed by
the major search engines. A new set of extremely promising schemas for
technical materials is in review which I plan to incorporate.

Encoding markup with microdata has a secondary benefit. Semantic HTML5
is challenging. Many elements can legitimately be marked up in
multiple ways depending on context. I often find that ambiguous
elements resolve themselves as I work through a schema.

## <a name="convention"></a>convention over configuration

### <a name="waldo"></a>where's waldo?

I spend a lot of my time in Rails; one of the strengths of the Rails
architecture is how easy it is to find
things. [Sass](http://sass-lang.com/)'s `@import` facility made it
possible for me to create a similar architecture in Octoburn.

Consider, for example, the follow menu at the top of each page:

* the template is `_includes/menus/follow_menu.html`
* the sass is `menus/_follow_menu.scss`

(There's more to the Sass import design, but a proper treatment would
be a full post.) 

### <a name="tags"></a>tags are not categories

Octoburn offers built-in support for tags: automatically generated 
tag pages, liquid filters for a single tag link and a full set of
tag links and automatically generated tag feeds. I am currently reviewing
several of the existing Jekyll tag cloud plugins to see if one of them
will do.

## <a name="next"></a>what's next?

While I have lots of plans for Octoburn, my next step is to turn it
into a gem. Hi, my name is Hilary, and I addicted to agile software
development. I need my BDD toolset!

 *[BDD]: Behavior-Driven Development