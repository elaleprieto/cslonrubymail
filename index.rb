# encoding: utf-8
require 'csv'
# require 'smtp_google_mailer'
require_relative 'smtp_google_mailer'

mailer = SMTPGoogleMailer.new "data.yaml"
from = 'contacto@colectivolibre.com.ar'

# archivo = 'inscripciones_ASISTENTES.csv'
archivo = 'inscripciones_aux.csv'
certificates_no_existentes = 0
faltantes = []

# CSV.open(archivo, 'r', ';') do |row|
#   puts row
# end

CSV.foreach(archivo, quote_char: '"', col_sep: ',', row_sep: :auto, headers: false) do |row|
  lastname = row[0]
  name = row[1]
  email = row[2]
  # user = email.split('@')[0]
  user = name.downcase.tr(' ','') + lastname.downcase.tr(' ', '')
  certificate = "Certificado-#{user}.pdf"
  attachment = "certificados/#{certificate}"

  subject = "Certificado de Asistencia"
  message = "¡Hola #{name}!\n\n"
  message += "Adjuntamos el certificado de asistencia a la Conferencia de Software Libre del Litoral.\n\n"
  message += "¡Gracias por tu presencia!"

  if File.file?(attachment)
  	# puts "#{user} :: #{certificate} :: ¿existe? " + (File.file?('certificates/' + certificate)).to_s
  	puts "Enviando certificado de #{user}"
  	# mailer.send_attachment_email from, to, subject, body, attachment
  	mailer.send_attachment_email from, email, subject, message, attachment
  else
  	certificates_no_existentes += 1
  	faltantes.push("#{lastname}, #{name}")
  end
end

# certificates faltantes
if certificates_no_existentes > 0
	faltantes.each do|f|
		puts "Falta: #{f}"
	end 
	
	puts "\ncertificates no existentes: #{certificates_no_existentes}"
else
	puts "\nTodos los certificates fueron encontrados :)"
end

puts ""