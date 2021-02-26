#!/usr/bin/env ruby
option = ARGV[0]
filename = ARGV[1]


# Con esto comprobamos si el paquete está instalado

def check(f_paquete)
  status = `whereis #{f_paquete[0]} |grep bin |wc -l`.to_i
    if status == 0
      puts "#{f_paquete[0]} -> Desinstalado"
    elsif status == 1
      puts "#{f_paquete[0]} -> Instalado"
    end
end

# Con esto instalamos o desinstalamos el programa

def install(f_paquete)
  status = `whereis #{f_paquete[0]} |grep bin |wc -l`.to_i
  action = "#{f_paquete[1]}".to_s

if action == "install"
    if status == 0
      `apt-get install -y #{f_paquete[0]}`
      puts "#{f_paquete[0]} -> Este paquete se instaló hace nada"
    elsif status == 1
      puts "#{f_paquete[0]} -> Este paquete ya estaba instalado"
    end

  elsif action == "remove"
      if status == 1
        `apt-get remove -y  #{f_paquete[0]}`
        puts "#{f_paquete[0]} -> Este paquete se ha desinstalado"
      elsif status == 0
        puts "#{f_paquete[0]} -> Este paquete no está instalado"
      end
  end
end

if option.nil?
  puts 'Comando ejecutado sin argumentos, para más ayuda, ejecuta --help'
elsif option == '--help'
  puts "Usage:
        systemctml [OPTIONS] [FILENAME]
Options:
        --help, mostrar esta ayuda.
        --version, mostrar información sobre el autor del script
                   y fecha de creación.
        --status FILENAME, comprueba si puede instalar/desintalar.
        --run FILENAME, instala/desinstala el software indicado.
Description:
        Este script se encarga de instalar/desinstalar
        el software indicado en el fichero FILENAME.
        Ejemplo de FILENAME:
        tree:install
        nmap:install
        atomix:remove"
elsif option == "--version"
  puts "  Autor : Abián Gustavo Castañeda Méndez
  Fecha de Creación : 26/02/2021"



elsif option == "--status"
  archivo = `cat FILENAME.txt`
  f_lines = archivo.split("\n")
  f_lines.each do |a|
    f_paquete = a.split(":")
    check(f_paquete)
  end
  

elsif option == "--run"
  user = `whoami`.chop

  if user == "root"
    archivo = `cat FILENAME.txt`
    f_lines = archivo.split("\n")
    f_lines.each do |a|
      f_paquete = a.split(":")
      install(f_paquete)
    end

elsif user != "root"
    puts "Se necesita ser usuario root para ejecutar el script"
    exit 1
  end
end
