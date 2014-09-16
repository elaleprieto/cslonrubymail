# encoding: utf-8
require 'csv'
require_relative 'smtp_google_mailer'

mailer = SMTPGoogleMailer.new "data.yaml"
from = '"Colectivo Libre" \<contacto@colectivolibre.com.ar\>'

# archivo = 'inscripciones_ASISTENTES.csv'
archivo = 'inscripciones_aux.csv'
certificates_no_existentes = 0
faltantes = []

CSV.foreach(archivo, quote_char: '"', col_sep: ',', row_sep: :auto, headers: false) do |row|
  lastname = row[0]
  name = row[1]
  email = row[2]
  user = name.downcase.tr(' ','') + lastname.downcase.tr(' ', '')
  certificate = "Certificado-#{user}.pdf"
  attachment = "certificados/#{certificate}"

  subject = "Certificado de Asistencia"
  message = "<p>¡Hola #{name}!</p>"
  message += "<p>Adjuntamos el certificado de asistencia a la Conferencia de Software Libre del Litoral.</p>"
  message += "<p>¡Gracias por tu presencia!</p>"
  message.force_encoding("ASCII-8BIT") # fuerza el encoding y evita el warning: regexp match /.../n against to UTF-8 string

  if File.file?(attachment)
    puts "Enviando certificado de #{user}"
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