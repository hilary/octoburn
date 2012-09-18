require 'to_slug'

# encoding: utf-8
#
# Jekyll tag page generator.
#
# Version: 0.0.3 (20120917)
#
# Copyright (c) 2012 Hilary J Holz, http://hholz.com/
# Licensed under the MIT license 
#  (http://www.opensource.org/licenses/mit-license.php)
# 
# Generates tag index pages and tag feeds for hholz.com
#
# Also includes related filters (due to Liquid's limitations)
# - tag_link  : outputs a microdata compliant link to a single tag index page
# - tag_links : outputs a <nav class="tag-list"> block containing a <ul> 
#                comprised of a tag_link (as above) per tag. 
#
# see constants in GenerateTagIndexes class for available
# _config.yml settings
#
module Jekyll

  class TagIndex < Page

    def initialize(site, attr)

      @site = site
      @base = attr[:source_dir]
      @dir  = attr[:dir]
      @name = attr[:name]
      self.process(@name)

      self.read_yaml(attr[:layout_dir], attr[:layout_filename])

      self.data['tag']         = attr[:tag]
      self.data['title']       = "#{attr[:title_prefix]}#{attr[:tag]}"
      self.data['description'] = "#{attr[:description_prefix]}#{attr[:tag]}"
      self.data['date']        = "#{Time.now.strftime('%Y-%m-%d %H:%M')}"

      if attr[:service] == :atom 
        self.data['feed_url'] = "#{dir}/#{name}" 
      end

    end # initialize
  end # class TagIndex

  class Site # we have to open Site to gain access to site_payload hash

    def write_tag_index(attr)

      attr[:service]         = :html
      attr[:name]            = "#{attr[:tag_slug]}.html"
      attr[:dir]             = attr[:tag_dir]
      attr[:layout_filename] = attr[:index_layout_filename]

      index = TagIndex.new(self, attr)

      index.render(self.layouts, site_payload)
      index.write(self.dest)
      self.pages << index

    end # def write_tag_index

    def write_tag_feed(attr)

      attr[:service]         = :atom
      attr[:name]            = "#{attr[:tag_slug]}.xml"
      attr[:dir]             = attr[:feed_dir]
      attr[:layout_filename] = attr[:feed_layout_filename]

      feed = TagIndex.new(self, attr)

      feed.render(self.layouts, site_payload)
      feed.write(self.dest)
      self.pages << feed

    end # def write_tag_feed

    def index_tags(attr)

      attr[:source_dir] = self.source
      attr[:layout_dir] = File.join(attr[:source_dir], '_layouts')
      attr[:tag_dir]    = self.config['tag_dir']

      if self.config['tag_feeds']
        attr[:feed_dir] = self.config['feed_dir']
      end

      self.tags.keys.each do |tag|

        attr[:tag]      = tag
        attr[:tag_slug] = tag.to_slug

        self.write_tag_index(attr)
        if self.config['tag_feeds']
          self.write_tag_feed(attr)
        end
      end

    end # index_tags

  end # class Site

  class GenerateTagIndexes < Generator
    safe true
    priority :low

    TAG_TITLE_PREFIX           = ''
    TAG_DESCRIPTION_PREFIX     = 'index of posts tagged: '
    TAG_INDEX_LAYOUT           = 'tag_index'

    TAG_FEEDS                  = false
    TAG_FEED_LAYOUT            = 'tag_feed'

    def generate(site)

      title_prefix          = site.config['tag_title_prefix'] || TAG_TITLE_PREFIX
      description_prefix    = site.config['tag_description_prefix'] ||
                                TAG_DESCRIPTION_PREFIX
      index_layout_filename = tag_layout(site, 'index') + ".html"

      attr = { 
        :title_prefix => title_prefix,
        :description_prefix => description_prefix, 
        :index_layout_filename => index_layout_filename 
      }

      if site.config['tag_feeds']
        attr[:feed_layout_filename] = tag_layout(site, 'feed') + '.xml'
      end
      site.index_tags(attr)

    end # generate

    private

    def tag_layout(site, service)

      layout = site.config["tag_#{service}_layout"] || 
               GenerateTagIndexes.const_get("TAG_#{service}_LAYOUT".upcase)

      if site.layouts.key? layout
        return layout
      else
        throw "Could not find layout #{layout}"
      end
        
    end

  end # class GenerateTagIndexes

  module Filters

    def tag_link(entry)
      tag_url = "#{context.registers[:site].config['root']}/" +
                "#{context.registers[:site].config['tag_dir']}/" +
                "#{entry.to_slug}.html"
      '<a rel="tag" href="' + tag_url + 
        '"><span itemprop="keywords">' + "#{entry}</span></a>"
    end

    def tag_links(tag_list)
      tags = tag_list.sort!.map { |entry| "<li>#{tag_link(entry)}</li>" }
      
      if tags.length == 0
        ""
      else
        '<nav class="tag-list"><ul>' + tags.to_s + '</ul></nav>'
      end

    end

end

