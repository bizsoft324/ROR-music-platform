module ApplicationHelper
  def user_avatar(user)
    if user.blank?
      image_tag 'artist-thumb.jpg'
    else
      image_tag user.avatar_url(:thumb)
    end
  end

  def thredded_user_avatar(user)
    if user.blank?
      image_tag 'artist-thumb.jpg', class: 'thredded--post--avatar'
    else
      image_tag user.avatar_url(:thumb), class: 'thredded--post--avatar'
    end
  end

  # def critique_show_link(critiques_count, track_id)
  #   link_to I18n.t('count_critiques', count: critiques_count), critique_path(track_id), class: 'player__title player__title--beat', remote: true
  # end
  def rating_link(track_id, rating_type, star)
    if authenticated? && current_user.ratings.any? { |r| r.track_id == track_id && r.status == star }
      link_to (inline_svg "range-#{rating_type}.svg"), track_ratings_path(track_id, star), class: "on_rating image_#{track_id} disabled", id: track_id, data: { rating: star, image: track_id }
    else
      link_to (inline_svg "range-#{rating_type}.svg", class: star), track_ratings_path(track_id, star), class: "on_rating image_#{track_id}", id: track_id, data: { rating: star, image: track_id }
    end
  end

  def arrow_wait
    image_tag 'arrow.gif', class: 'send_comment--wait'
  end

  def extract_url(url)
    parsed = URI.parse(url)
    parsed.fragment = parsed.query = nil
    parsed.to_s
  end

  def genre_checked?(genres, check_box_genre)
    genres&.include?(check_box_genre)
  end

  def soundbite_player(soundbite)
    sound = false

    if soundbite.data_url
      sound = "data-url='#{soundbite.data_url}'"
    elsif soundbite.data_id
      sound = "data-id='#{soundbite.data_id}'"
    end

    return sound unless sound

    "<span class='soundcite' #{sound} data-start='#{soundbite.data_start}' data-end='#{soundbite.data_end}' data-plays='#{soundbite.data_plays}'> #{soundbite.title} </span>".html_safe
  end

  def sort_params
    [['Newest-Oldest', 'recent'], ['Oldest-Newest', 'old']]
  end

  def spinner_loader
    '<div class="spinner-loader"></div>'
  end

  def checkbox_default(field, description_or_options = nil, options = nil, &block)
    if block_given?
      options = description_or_options if description_or_options.is_a?(Hash)
      content_for_checkbox(field, capture(&block), options)
    else
      content_for_checkbox(field, description_or_options, options)
    end
  end

  def content_for_checkbox(field, description, options)
    options ||= {}
    id = options[:id] || sanitize_to_id(field)
    content_tag(:div, class: %w[checkbox-default] << options[:class]) do
      html = check_box_tag field, options[:value] || 1, options[:checked], class: 'toggle-input', data: options[:data], id: id
      label = label_tag id, class: 'toggle-label' do
        content_tag(:span, '', class: %w[toggle-checkbox uk-icon-check] << options[:checkbox_class]) <<
          content_tag(:span, description, class: %w[description-checkbox] << options[:label_class])
      end
      html << label
    end
  end

  def chart_by_period
    { 'month' => date.month,
      'week' => date.cweek,
      'day' => date.yday }
  end

  def js_flash
    "$('#toastr_messages').data(#{flash.to_hash.to_json}); showFlash();".html_safe
  end
end
