require 'mail'
require 'yaml'
 
class SMTPGoogleMailer
  attr_accessor :smtp_info

  def initialize(data)
    self.smtp_info = 
      begin
        YAML.load_file(data)
      rescue
        $stderr.puts "Could not find SMTP info"
        exit -1
      end

  end
 
  def send_attachment_email from, to, subject, body, attachment
    options = {:address => @smtp_info[:smtp_server], 
        :port => @smtp_info[:smtp_port], 
        :user_name => @smtp_info[:username], 
        :password => @smtp_info[:password], 
        :enable_ssl => true}

    Mail.defaults do
      delivery_method :smtp, options
    end

    Mail.deliver do
      from from
      to to
      subject subject

      html_part do
        content_type 'text/html; charset=UTF-8'
        body body
      end

      add_file attachment
    end
  end
end