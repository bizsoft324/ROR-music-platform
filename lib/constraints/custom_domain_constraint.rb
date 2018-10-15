class CustomDomainConstraint
  def matches?(request)
    request.subdomain == 'beat-thread-beta' || request.subdomain.blank? || request.subdomain == 'www' || ArtistSubdomain.where(slug: request.subdomain).any?
  end
end
