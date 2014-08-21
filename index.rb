require 'csv'

archivo = 'inscripciones_ASISTENTES.csv' 

# CSV.open(archivo, 'r', ';') do |row|
#   puts row
# end

CSV.foreach(archivo, quote_char: '"', col_sep: ',', row_sep: :auto, headers: false) do |row|
  apellido = row[0]
  nombre = row[1]
  correo = row[2]
  # usuario = correo.split('@')[0]
  usuario = nombre.downcase.tr(' ','') + apellido.downcase.tr(' ', '')
  certificado = 'Certificado-' + usuario + '.pdf'
  puts usuario + ' :: ' + certificado
end