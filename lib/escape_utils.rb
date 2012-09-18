require File.expand_path('../escape_utils',  __FILE__)
require File.expand_path('../version',  __FILE__) unless defined? EscapeUtils::VERSION

module EscapeUtils
  extend self

  # turn on/off the escaping of the '/' character during HTML escaping
  # Escaping '/' is recommended by the OWASP - http://www.owasp.org/index.php/XSS_(Cross_Site_Scripting)_Prevention_Cheat_Sheet#RULE_.231_-_HTML_Escape_Before_Inserting_Untrusted_Data_into_HTML_Element_Content
  # This is because quotes around HTML attributes are optional in most/all modern browsers at the time of writing (10/15/2010)
  @@html_secure = true

  autoload :HtmlSafety, File.expand_path('../html_safety',  __FILE__)
end