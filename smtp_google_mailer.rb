require 'net/smtp'
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
 
  def send_plain_email from, to, subject, body
    mailtext = <<EOF
From: #{from}
To: #{to}
Subject: #{subject}
 
#{body}
EOF
    send_email from, to, mailtext
  end
 
  def send_attachment_email from, to, subject, body, attachment
    # Read a file and encode it into base64 format
    begin
      filecontent = File.read(attachment)
      encodedcontent = [filecontent].pack("m")   # base64
    rescue
      raise "Could not read file #{attachment}"
    end
 
    marker = (0...50).map{ ('a'..'z').to_a[rand(26)] }.join
    part1 =<<EOF
From: #{from}
To: #{to}
Subject: #{subject}
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=#{marker}
--#{marker}
EOF
 
    # Define the message action
    part2 =<<EOF
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding:8bit
 
#{body}
<img src="https://www.dropbox.com/s/smxptzkzboz6wt7/banner.jpg?dl=1" />
--#{marker}
EOF
 
    # Define the attachment section
    part3 =<<EOF
Content-Type: multipart/mixed; name=\"#{File.basename(attachment)}\"
Content-Transfer-Encoding:base64
Content-Disposition: attachment; filename="#{File.basename(attachment)}"
 
#{encodedcontent}
--#{marker}--
EOF
 
    mailtext = part1 + part2 + part3
    mailtext.force_encoding("ASCII-8BIT")
 
    send_email from, to, mailtext
  end
 
  private
 
  def send_email from, to, mailtext
    begin 
      smtp = Net::SMTP.new  @smtp_info[:smtp_server], @smtp_info[:port]
      smtp.enable_starttls
      smtp.start(@smtp_info[:helo], @smtp_info[:username], @smtp_info[:password], @smtp_info[:authentication]) do |smtp|
        smtp.send_message mailtext, from, to
      end
    rescue => e  
      raise "Exception occured: #{e} "
      exit -1
    end  
  end
end