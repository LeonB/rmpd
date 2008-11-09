#This is where monkey patches live
class File
  def extension
    File.extname(self.path)
  end
end

def camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
  if first_letter_in_uppercase
    lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
  else
    lower_case_and_underscored_word.first + camelize(lower_case_and_underscored_word)[1..-1]
  end
end

def constantize(camel_cased_word)
  unless /\A(?:::)?([A-Z]\w*(?:::[A-Z]\w*)*)\z/ =~ camel_cased_word
    raise NameError, "#{camel_cased_word.inspect} is not a valid constant name!"
  end
  
  Object.module_eval("::#{$1}", __FILE__, __LINE__)
end

def only_with_plugins(&block)
  old_argv = ARGV.dup
  start_recording = false
  arguments = []

  ARGV.each do |argument|
    if not start_recording
      if argument == '-p' or argument == '--plugins'
        arguments << argument
        start_recording = true
      end
    else
      if not argument[0,1] == '-'
        arguments << argument
      else
        break
      end
    end
  end

  ARGV.replace(arguments)
  block.call
  ARGV.replace(old_argv)
end