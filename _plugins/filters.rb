module CustomFilters
  @@randomised = nil
  def random_post_link(post, all_posts)
    if @@randomised.nil?
      by_url = Hash.new
      all = all_posts.shuffle
      prev = all[-1]
      all.each do |post|
        by_url[post.url] = prev.url
        prev = post
      end
      @@randomised = by_url
    end
    @@randomised[post.url]
  end
end

Liquid::Template.register_filter(CustomFilters)

