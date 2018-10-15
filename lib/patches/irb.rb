module IRB::WorkSpace::Patches
  APPDIR_REGEXP = /\A#{Regexp.escape Rails.root.to_path}/
  TOP_MARK = ">'".freeze
  DOT = '.'.freeze
  def filter_backtrace(bt)
    (bt = super) && bt.gsub!(APPDIR_REGEXP, DOT) && (bt unless bt.end_with? TOP_MARK)
  end
end
IRB::WorkSpace.prepend IRB::WorkSpace::Patches
