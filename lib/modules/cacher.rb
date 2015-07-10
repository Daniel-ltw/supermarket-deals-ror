module Cacher
  def cache_retrieve_url(val)

    if @cache.fetch(val).present?
      return @cache.fetch(val) if @cache.fetch(val).match(/(\s500\s)/) # match " 500 " for 500 error
    end

    @cache.delete(val)

    sleep rand(1.0..10.0)

    @cache.write(val, nokogiri_open_url(HOME_URL + val).to_html, expires_in: Midnight.seconds_to_midnight.seconds)

    @cache.fetch(val)
  end
end
