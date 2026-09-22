module CustomFilters
  def smart_date(input)
    build_time = @context.registers[:site].time
    if input.strftime('%F') == build_time.strftime('%F')
      build_time
    else
      input
    end
  end

  @@randomised = nil
  def random_post_link(post)
    post ||= @context.registers[:site].posts.docs.sample
    if @@randomised.nil?
      by_url = Hash.new
      all = @context.registers[:site].posts.docs.shuffle
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

