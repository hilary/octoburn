# encoding: utf-8
#
# Jekyll tag page generator.
#
# Version: 0.0.3 (20120917)
#
# This work is licensed by Hilary J Holz (http://hholz.com/,
# hilary@hholz.com) under the Creative Commons
# Attribution-NonCommercial-ShareAlike 3.0 Unported License. To view a
# copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter
# to Creative Commons, 444 Castro Street, Suite 900, Mountain View,
# California, 94041, USA.
# 
# Generates tag index pages and tag feeds for hholz.com
#
# See microdata_filters.rb plugin for related filters
#
# see constants in GenerateTagIndexes class for available
# _config.yml settings
#
require 'to_slug'

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
      self.data['date']        = attr[:updated]

      self.data['feed_url'] = "#{dir}/#{name}" if attr[:service] == :atom 

    end # initialize
  end # class TagIndex

  class Site # we have to open Site to gain access to site_payload hash

    def write_tag_index(attr)

      index = TagIndex.new(self, attr)

      index.render(self.layouts, site_payload)
      index.write(self.dest)
      self.pages << index

    end # write_tag_index

    def write_tag_page(attr)

      attr[:service]         = :html
      attr[:name]            = "#{attr[:tag_slug]}.html"
      attr[:dir]             = attr[:tag_dir]
      attr[:layout_filename] = attr[:page_layout_filename]

      write_tag_index(attr)

    end # write_tag_page

    def write_tag_feed(attr)

      attr[:service]         = :atom
      attr[:name]            = "#{attr[:tag_slug]}.xml"
      attr[:dir]             = attr[:feed_dir]
      attr[:layout_filename] = attr[:feed_layout_filename]

      write_tag_index(attr)

    end # write_tag_feed

    def index_tags(attr)

      attr[:source_dir] = self.source
      attr[:layout_dir] = File.join(attr[:source_dir], '_layouts')
      attr[:tag_dir]    = self.config['tag_dir']
      attr[:updated]    = "#{Time.now.strftime('%Y-%m-%d %H:%M')}"

      attr[:feed_dir] = self.config['feed_dir'] if self.config['tag_feeds']

      self.tags.keys.each do |tag|

        attr[:tag]      = tag.sub(/,\z/, '')
        attr[:tag_slug] = tag.to_slug

        self.write_tag_page(attr)
        self.write_tag_feed(attr) if self.config['tag_feeds']

      end

    end # index_tags

  end # class Site

  class GenerateTagIndexes < Generator
    safe true
    priority :low

    TAG_TITLE_PREFIX       = 'tag: '
    TAG_DESCRIPTION_PREFIX = 'index of posts tagged: '
    TAG_PAGE_LAYOUT        = 'tag_page'

    TAG_FEEDS              = false
    TAG_FEED_LAYOUT        = 'tag_feed'

    def generate(site)

      title_prefix          = site.config['tag_title_prefix'] || TAG_TITLE_PREFIX
      description_prefix    = site.config['tag_description_prefix'] ||
                                TAG_DESCRIPTION_PREFIX
      page_layout_filename = tag_layout(site, 'page') + ".html"

      attr = { 
        :title_prefix => title_prefix,
        :description_prefix => description_prefix, 
        :page_layout_filename => page_layout_filename 
      }

      attr[:feed_layout_filename] = tag_layout(site, 'feed') + '.xml' if site.config['tag_feeds']

      site.index_tags(attr)

    end # generate

    private

    def tag_layout(site, service)

      service_layout = site.config["tag_#{service}_layout"] || 
               GenerateTagIndexes.const_get("TAG_#{service}_LAYOUT".upcase)

      if site.layouts.key? service_layout 
        return service_layout 
      else 
        throw "Could not find layout #{layout}"
      end
    end

  end # class GenerateTagIndexes

end

