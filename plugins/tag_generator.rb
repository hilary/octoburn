# encoding: utf-8
#
# Jekyll tag page generator.
#
# Version: 0.0.1 (20120906)
#
# Copyright (c) 2012 Hilary J Holz, http://hholz.com/
# Licensed under the MIT license (http://www.opensource.org/licenses/mit-license.php)
# 
# After Dave Perrett's Category Generator plugin
#
# Creates tag pages for jekyll sites.
#
# _config.yml settings
#   tag_dir                     : string: where to build the tag pages 
#                                  default: 'tags'
#   tag_title_prefix            : string: used before tag name in page title 
#                                  default: 'posts tagged: '
#   tag_meta_description_prefix : string: used before tag name in page description
#                                  default: 'index of posts tagged: '
#   tag_index_layout            : string: filename of layout for tag pages
#                                  default: 'tag_index'
#   tag_index_layout_extension  : string: extension of layout for tag pages
#                                  default: 'html'
module Jekyll

  class TagIndex < Page

    def initialize(site, base, tag_dir, tag_index_layout, tag)
      @site             = site
      @base             = base
      @dir              = tag_dir
      @tag_index_layout = tag_index_layout
      @name             = 'index.html'
      self.process(@name)


      tag_index_layout_extension = site.config['tag_index_layout_extension'] || 'html'
      tag_index_layout_filename = "#{tag_index_layout}.#{tag_index_layout_extension}"

      self.read_yaml(File.join(base, '_layouts'), tag_index_layout_filename)

      self.data['tag'] = tag

      title_prefix       = site.config['tag_title_prefix'] || 'Posts tagged: '
      self.data['title'] = "#{title_prefix}#{tag}"

      meta_description_prefix  = site.config['tag_meta_description_prefix'] 
                                  || 'Index of posts tagged: '
      self.data['description'] = "#{meta_description_prefix}#{tag}"
    end

  end

  class TagAtomFeed < Page 

    def initialize(site, base, tag_dir, tag)
      @site = site
      @base = base
      @dir  = tag_dir
      @name = 'atom.xml'
      self.process(@name)

      self.read_yaml(File.join(base, '_includes/custom'), 'tag_feed.xml')
      self.data['tag'] = tag

      title_prefix       = site.config['tag_title_prefix'] || 'posts tagged: '
      self.data['title'] = "#{title_prefix}#{tag}"

      meta_description_prefix  = site.config['tag_meta_description_prefix']
                                  || 'index of posts tagged: '
      self.data['description'] = "#{meta_description_prefix}#{tag}"

      self.data['feed_url'] = "#{tag_dir}/#{name}"
    end

  end

  class Site # built-in Jekyll class with access to global site config information.

    def write_tag_index(tag_dir, tag)
      index = TagIndex.new(self, self.source, tag_dir, tag_index_layout, tag)
      index.render(self.layouts, site_payload)
      index.write(self.dest)
      
      self.pages << index # so Site::cleanup does not remove it.

      if self.config['tag_feeds']
        feed = TagAtomFeed.new(self, self.source, tag_dir, tag)
        feed.render(self.layouts, site_payload)
        feed.write(self.dest)

        self.pages << feed # so Site::cleanup does not remove it.
      end
    end

    def write_tag_indexes(tag_index_layout = 'tag_index')
      if self.layouts.key? tag_index_layout
        dir = self.config['tag_dir']
        self.tags.keys.each do |tag|
          tag_slug = tag.gsub(/_|\P{Word}/, '-').gsub(/-{2,}/, '-').downcase
          if dir.nil? or dir.empty?
            self.write_tag_index(tag_slug, tag)
          else
            self.write_tag_index(File.join(dir, tag_slug), tag)
          end
        end

      else
        throw "No #{tag_index_layout} layout found."
      end
    end

  end

  class GenerateTags < Generator
    safe true
    priority :low

    def generate(site) # generate called by jekyll
      if site.config['tag_index_layout']
        site.write_tag_indexes(site.config['tag_index_layout'])
      else
        site.write_tag_indexes
      end
    end

  end

end

