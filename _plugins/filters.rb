module CustomFilters
  def random_post_link(post, all_posts)
    if @randomised.nil?
      shuf = all_posts.shuffle
      by_url = Hash.new
      all = all_posts.shuffle
      prev = all[-1]
      all.each do |post|
        by_url[post.url] = prev.url
      end
      @randomised = by_url
    end
    @randomised[post.url]
  end
end

Liquid::Template.register_filter(CustomFilters)

