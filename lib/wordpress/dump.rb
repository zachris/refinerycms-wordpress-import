module Refinery
  module WordPress
    class Dump
      attr_reader :doc

      def initialize(file_name)
        file_name = File.absolute_path(file_name)

        raise "Given file '#{file_name}' no file or not readable." \
          unless File.file?(file_name) && File.readable?(file_name)
        
        file = File.open(file_name)
        @doc = Nokogiri::XML(file)
      end

      def authors
        doc.xpath("//wp:author").collect do |author|
          Author.new(author)
        end
      end

      def pages
        doc.xpath("//item[wp:post_type = 'page']").collect do |page|
          Page.new(page)
        end
      end

      def posts
        doc.xpath("//item[wp:post_type = 'post']").collect do |post|
          Post.new(post)
        end
      end

      def tags
        doc.xpath("//wp:tag/wp:tag_slug").collect do |tag|
          Tag.new(tag.text)
        end
      end

      def categories
        doc.xpath("//wp:category/wp:cat_name").collect do |category|
          Category.new(category.text)
        end
      end
    end
  end
end