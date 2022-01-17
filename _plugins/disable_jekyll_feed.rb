# We disable `jekyll-feed` without modifying `minima` by replacing key methods with noops.
JekyllFeed::MetaTag.define_method(:render, lambda { |_| })
JekyllFeed::Generator.define_method(:generate, lambda { |_| })
