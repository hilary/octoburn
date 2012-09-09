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

    def initialize(service, site, tag, name,
                   source_dir, layout_dir, dir,
                   layout_filename, title_prefix, description_prefix)
      @site = site
      @base = source_dir
      @dir  = dir
      @name = name
      self.process(@name)

      self.read_yaml(layout_dir, layout_filename)

      self.data['tag']         = tag
      self.data['title']       = "#{title_prefix}#{tag}"
      self.data['description'] = "#{description_prefix}#{tag}"
      self.data['date']        = "#{Time.now.strftime('%Y-%m-%d %H:%M')}"

      if service == :atom 
        self.data['feed_url'] = "#{dir}/#{name}" 
      end
    end

  end

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

      source_dir            = site.source
      layout_dir            = File.join(source_dir, '_layouts')
      index_layout_filename = tag_index_layout +
        ".#{site.config['tag_index_layout_extension'] || TAG_INDEX_LAYOUT_EXTENSION}"
      title_prefix          = site.config['tag_title_prefix'] || TAG_TITLE_PREFIX
      description_prefix    = site.config['tag_description_prefix'] || 
                                TAG_DESCRIPTION_PREFIX

      if site.config['tag_feeds']
        feed_layout_filename = tag_feed_layout + '.xml'
      end

      site.tags.keys.each do |tag|

        index = TagIndex.new(:html, site, tag, "#{tag}_index.html",
                             source_dir, layout_dir, site.config['tag_dir'],
                             index_layout_filename, title_prefix, description_prefix)

        index.render(site.layouts, site_payload)
        index.write(site.dest)
        site.pages << index

        if site.config['tag_feeds']

          feed = TagIndex.new(:atom, site, tag, "#{tag}_feed.xml",
                             source_dir, layout_dir, site.config['feed_dir'],
                             feed_layout_filename, title_prefix, description_prefix)

          feed.render(site.layouts, site_payload)
          feed.write(site.dest)
          site.pages << feed
        end

      end # site.tags.keys.each

    end # generate

    private

    def tag_index_layout

      index_layout = site.config['tag_index_layout'] || TAG_INDEX_LAYOUT
      unless site.layouts.key? index_layout
        throw "Could not find layout #{index_layout}"
      end

      return index_layout
    end

    def tag_feed_layout

      feed_layout = site.config['tag_feed_layout'] || TAG_FEED_LAYOUT
      unless site.layouts.key? feed_layout
        throw "Could not find atom feed layout #{feed_layout}"
      end
        
      return feed_layout
    end

  end # class GenerateTagIndexes

end

