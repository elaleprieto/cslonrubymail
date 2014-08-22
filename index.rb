# encoding: utf-8
require 'csv'

archivo = 'inscripciones_ASISTENTES.csv'
certificados_no_existentes = 0
faltantes = []

# CSV.open(archivo, 'r', ';') do |row|
#   puts row
# end

CSV.foreach(archivo, quote_char: '"', col_sep: ',', row_sep: :auto, headers: false) do |row|
  apellido = row[0]
  nombre = row[1]
  correo = row[2]
  # usuario = correo.split('@')[0]
  usuario = nombre.downcase.tr(' ','') + apellido.downcase.tr(' ', '')
  certificado = "Certificado-#{usuario}.pdf"

  if File.file?('certificados/' + certificado)
  	puts "#{usuario} :: #{certificado} :: ¿existe? " + (File.file?('certificados/' + certificado)).to_s
  else
  	certificados_no_existentes += 1
  	faltantes.push("#{apellido}, #{nombre}")
  end
end

# Certificados faltantes
if certificados_no_existentes > 0
	faltantes.each do|f|
		puts "Falta: #{f}"
	end 
	
	puts "\nCertificados no existentes: #{certificados_no_existentes}"
else
	puts "\nTodos los certificados fueron encontrados :)"
end

puts ""