# encoding: utf-8
#
# Jekyll microdata compliant filters.
#
# Version: 0.0.1 (20120918)
#
# This work is licensed by Hilary J Holz (http://hholz.com/,
# hilary@hholz.com) under the Creative Commons
# Attribution-NonCommercial-ShareAlike 3.0 Unported License. To view a
# copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter
# to Creative Commons, 444 Castro Street, Suite 900, Mountain View,
# California, 94041, USA.
# 
# The following two filters are related to my tag_generator.rb plugin,
# but may be used indepedently of it
# - tag_link  : outputs a microdata compliant link 
#               (itemprop="keywords")to a single tag index page
# - tag_links : outputs a <nav class="tag-links"> block containing a <ul> 
#                comprised of a tag_link (as above) per tag. 
#
# The date_published filter requires the Octopress date.rb Jekyll plugin

require 'to_slug'
require './plugins/date'

module MicrodataLiquidFilters
  include Octopress::Date

  def date_published(date, property = "published")
    return unless date.to_s.size > 0

    itemprop = (property == 'published') ? 'datePublished' : 'dateModified'

    date_formatted = format_date(date, 
      @context.registers[:site].config['date_format'])

    '<time datetime="' + date_to_xmlschema(datetime(date)) +
      '" itemprop="' + itemprop + '">' + "#{date_formatted}</time>"
  end

  def absolute_root
    @context.registers[:site].config['root']
  end

  def tag_link(entry)
    root = @context.registers[:site].config['root']
    tag_dir = @context.registers[:site].config['tag_dir']
    entry.sub!(/,\z/, '')
    '<a rel="tag" href="' + "#{root}#{tag_dir}/#{entry.to_slug}.html" +
      '"><span itemprop="keywords">' + "#{entry}</span></a>"
  end

  def tag_links(tag_list)
    tags = tag_list.sort!.map { |entry| "<li>#{tag_link(entry)}</li>" }
      
    tags.length == 0 ? "" : '<nav class="tag-links"><ul>' + tags.join + '</ul></nav>'
  end

  def permalink_url(url)
    root = @context.registers[:site].config['url']
    "#{root}#{url}"
  end

  def permalink(url)
    label = @context.registers[:site].config['permalink_label']
    '<a rel="bookmark" href="' + permalink_url(url) + '" itemprop="url">' + "#{label}</a>"
  end

  def excerpt_link(url)
    link_label = @context.registers[:site].config['excerpt_link']
    '<a rel="full-article" href="' + permalink_url(url) + '" itemprop="url">' + 
      "#{link_label}</a>"
  end

end
Liquid::Template.register_filter MicrodataLiquidFilters
