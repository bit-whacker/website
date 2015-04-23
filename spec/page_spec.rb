require 'yaml'
require 'cucumber/website/page'
require 'cucumber/website/config'

module Cucumber::Website
  describe Page do
    root = File.expand_path(File.join(File.dirname(__FILE__), "/../apps/dynamic"))
    views = File.join(root, 'views')

    extend Config
    config = load_config('test')

    it "exposes frontmatter as attributes" do
      template_path = File.dirname(__FILE__) + '/fixtures/some_page.md'
      page = Page.new(config, template_path, views)
      expect(page.arbitrary_frontmatter_attribute).to eq 'arbitrary frontmatter value'
    end

    it "can set attribute on page" do
      template_path = File.dirname(__FILE__) + '/fixtures/some_page.md'
      page = Page.new(config, template_path, views)
      page.new_attribute = 'yo'
      expect(page.new_attribute).to eq 'yo'
    end

    describe "as regular page" do
      it "has an url" do
        page = Page.new(config, File.join(views, 'school.slim'), views)
        #expect(post.url).to eq("")
      end
    end

    describe "as blog post" do
      it "has an url" do
        page = Page.new(config, File.join(views, '_posts/matt-on-test-talks.md'), views)
        #expect(post.url).to eq("")
      end
    end
  end
end
