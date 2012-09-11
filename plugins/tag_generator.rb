# encoding: utf-8
#
# Jekyll tag page generator.
#
# Version: 0.0.2 (20120907)
#
# Copyright (c) 2012 Hilary J Holz, http://hholz.com/
# Licensed under the MIT license 
#  (http://www.opensource.org/licenses/mit-license.php)
# 
# Creates tag pages and feeds for jekyll sites.
#
# see GenerateTagIndexes class for _config.yml settings
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

    def index_tags(attr)

      attr[:source_dir] = self.source
      attr[:layout_dir] = File.join(attr[:source_dir], '_layouts')
      attr[:tag_dir]    = self.config['tag_dir']

      if self.config['tag_feeds']
        attr[:feed_dir] = self.config['feed_dir']
      end

      self.tags.keys.each do |tag|

        attr[:tag] = tag

        self.write_tag_index(attr)
        if self.config['tag_feeds']
          self.write_tag_feed(attr)
        end
      end

    end # index_tags


    def write_tag_index(attr)

      attr[:service]         = :html
      attr[:name]            = "#{attr[:tag]}_index.html"
      attr[:dir]             = attr[:tag_dir]
      attr[:layout_filename] = attr[:index_layout_filename]

      index = TagIndex.new(self, attr)

      index.render(self.layouts, site_payload)
      index.write(self.dest)
      self.pages << index

    end # def write_tag_index

    def write_tag_feed(attr)

      attr[:service]         = :atom
      attr[:name]            = "#{attr[:tag]}_feed.xml"
      attr[:dir]             = attr[:feed_dir]
      attr[:layout_filename] = attr[:feed_layout_filename]

      feed = TagIndex.new(self, attr)

      feed.render(self.layouts, site_payload)
      feed.write(self.dest)
      self.pages << feed

    end # def write_tag_feed

  end # class Site

  class GenerateTagIndexes < Generator
    safe true
    priority :low

    TAG_TITLE_PREFIX           = ''
    TAG_DESCRIPTION_PREFIX     = 'index of posts tagged: '
    TAG_INDEX_LAYOUT           = 'tag_index'
    TAG_INDEX_LAYOUT_EXTENSION = 'html'

    TAG_FEEDS                  = false
    TAG_FEED_LAYOUT            = 'tag_feed'

    def generate(site)

      title_prefix          = site.config['tag_title_prefix'] || TAG_TITLE_PREFIX
      description_prefix    = site.config['tag_description_prefix'] ||
                                TAG_DESCRIPTION_PREFIX
      index_layout_filename = tag_index_layout(site) +
        ".#{site.config['tag_index_layout_extension'] || TAG_INDEX_LAYOUT_EXTENSION}"

      attr = { 
        :title_prefix => title_prefix,
        :description_prefix => description_prefix, 
        :index_layout_filename => index_layout_filename 
      }

      if site.config['tag_feeds']
        attr[:feed_layout_filename] = tag_feed_layout(site) + '.xml'
      end
      site.index_tags(attr)

    end # generate

    private

    def tag_index_layout(site)

      index_layout = site.config['tag_index_layout'] || TAG_INDEX_LAYOUT
      unless site.layouts.key? index_layout
        throw "Could not find layout #{index_layout}"
      end

      return index_layout
    end

    def tag_feed_layout(site)

      feed_layout = site.config['tag_feed_layout'] || TAG_FEED_LAYOUT
      unless site.layouts.key? feed_layout
        throw "Could not find atom feed layout #{feed_layout}"
      end
        
      return feed_layout
    end

  end # class GenerateTagIndexes

end

