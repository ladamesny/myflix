class Video < ActiveRecord::Base

  # def initialize(file=nil)
  #   if file
  #     self.sm_filename = sanitize_filename(file.original_filename)
  #     self.sm_content_type = file.content_type
  #     self.sm_file_contents = file.read
  #   end
  # end

  # def sanitize_filename(filename)
  #   # Get only the filename, not the whole path (for IE)
  #   # Thanks to this article I just found for the tip: http://mattberther.com/2007/10/19/uploading-files-to-a-database-using-rails
  #   return File.basename(filename)
  # end
end
