module Utility
  def self.search_hash(h, search)
    return h[search] if h.fetch(search, false)

    h.keys.each do |k|
      answer = search_hash(h[k], search) if h[k].is_a? Hash
      return true if answer
    end

    false
  end
end
