
class TestConfig

  def mode
    @mode
  end

  def mode=(value)
    @mode = value
  end

  def po_base_dir
    Pathname.new("sample/po").expand_path(File.dirname(File.dirname(__FILE__))).to_path
  end

end