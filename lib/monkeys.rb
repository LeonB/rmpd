#This is where monkey patches live
class File
  def extension
    File.extname(self.path)
  end
end