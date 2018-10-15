require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'spinner_loader' do
    it { expect(helper.spinner_loader).to eq '<div class="spinner-loader"></div>' }
  end

  describe 'checkbox_default' do
    it 'checkbox with min params' do
      expect(helper.checkbox_default('agree', 'Agree to terms & conditions')).to eq(
        '<div class="checkbox-default ">' \
          '<input type="checkbox" name="agree" id="agree" value="1" class="toggle-input" />' \
          '<label class="toggle-label" for="agree">' \
            '<span class="toggle-checkbox uk-icon-check "></span>' \
            '<span class="description-checkbox ">Agree to terms &amp; conditions</span>' \
          '</label>' \
        '</div>'
      )
    end

    it 'checkbox with options' do
      expect(helper.checkbox_default('agree', 'I am agree', value: true, checked: true, class: 'custom')).to eq(
        '<div class="checkbox-default custom">' \
          '<input type="checkbox" name="agree" id="agree" value="true" class="toggle-input" checked="checked" />' \
          '<label class="toggle-label" for="agree">' \
            '<span class="toggle-checkbox uk-icon-check "></span>' \
            '<span class="description-checkbox ">I am agree</span>' \
          '</label>' \
        '</div>'
      )
    end

    it 'checkbox with extra classes' do
      expect(helper.checkbox_default('user[agree]', 'I am agree',
                                     checkbox_class: 'checkbox_class', label_class: 'label_class',
                                     data: { 'parsley-required' => 'true', 'parsley-required-message' => 'Agreement required' })).to eq(
                                       '<div class="checkbox-default ">' \
                                         '<input type="checkbox" name="user[agree]" id="user_agree" value="1" class="toggle-input" data-parsley-required="true" data-parsley-required-message="Agreement required" />' \
                                         '<label class="toggle-label" for="user_agree">' \
                                           '<span class="toggle-checkbox uk-icon-check checkbox_class"></span>' \
                                           '<span class="description-checkbox label_class">I am agree</span>' \
                                         '</label>' \
                                       '</div>'
                                     )
    end

    it 'checkbox with blok' do
      block = content_tag(:span, 'I agree with you', class: ['description'])
      expect(helper.checkbox_default('agree') { block }).to eq(
        '<div class="checkbox-default ">' \
          '<input type="checkbox" name="agree" id="agree" value="1" class="toggle-input" />' \
          '<label class="toggle-label" for="agree">' \
            '<span class="toggle-checkbox uk-icon-check "></span>' \
            '<span class="description-checkbox ">' \
              '<span class="description">I agree with you</span>' \
            '</span>' \
          '</label>' \
        '</div>'
      )
    end
  end
end
