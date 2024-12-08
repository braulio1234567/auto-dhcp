#!/bin/bash
 if [ $(id -u) -eq 0 ]
	then
		while true
			do
				clear
				echo "
 _______          _________ _______  ______            _______  _______  ______     _______  _______  _______ _________ _______ _________
(  ___  )|\     /|\__   __/(  ___  )(  __  \ |\     /|(  ____ \(  ____ )(  __  \   (  ____ \(  ____ \(  ____ )\__   __/(  ____ )\__   __/
| (   ) || )   ( |   ) (   | (   ) || (  \  )| )   ( || (    \/| (    )|| (  \  )  | (    \/| (    \/| (    )|   ) (   | (    )|   ) (   
| (___) || |   | |   | |   | |   | || |   ) || (___) || |      | (____)|| |   ) |  | (_____ | |      | (____)|   | |   | (____)|   | |   
|  ___  || |   | |   | |   | |   | || |   | ||  ___  || |      |  _____)| |   | |  (_____  )| |      |     __)   | |   |  _____)   | |   
| (   ) || |   | |   | |   | |   | || |   ) || (   ) || |      | (      | |   ) |        ) || |      | (\ (      | |   | (         | |   
| )   ( || (___) |   | |   | (___) || (__/  )| )   ( || (____/\| )      | (__/  )  /\____) || (____/\| ) \ \_____) (___| )         | |   
|/     \|(_______)   )_(   (_______)(______/ |/     \|(_______/|/       (______/   \_______)(_______/|/   \__/\_______/|/          )_(   
                                                                                                                                         
"
				echo -e "1.Configurar dhcpd.conf\n2.Configurar interfaces\n3.Realizar una reserva\n4.Borrar configuración\n5.Reiniciar servicio\n6.Salir"
				read -p "Elije una opción: " opcion
				if [[ $opcion =~ ^[+]?[0-9]+$ ]]
					then
						if [ $opcion -eq 1 ]
							then
								read -p "¿Cuantos ámbitos quieres configurar?: " ambitos
								cont=1
								if [ $(find /etc/dhcp/dhcpd.conf 2>/dev/null | wc -l) -gt 0 ]
									then
										mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.copy
							 			echo "Realizando una copia de seguridad de el archivo dhcpd.conf ....."
								else
									echo "El archivo dhcpd.conf no existe... Omitiendo la copia..."
								fi
								sleep 3
								while [ $cont -le $ambitos ]
									do
										clear
										echo "Configurando el ámbito $cont"
										sleep 2
										read -p "Dime la direccion de red: " di_red
										read -p "Dime la máscara de red: " netmask
										read -p "Dime la ip de inicio del rango: " init_ip
										read -p "Dime la ip de fin del rango: " end_ip
										read -p "Dime la ip del servidor dns (si hay dos separadas por comas) : " ip_dns
										read -p "Dime el nombre de dominio de la red (entre comillas): " d_red
										read -p "Dime la puerta de enlace: " gateway
										read -p "Dime la dirección de broadcast: " broadcast
										read -p "Dime el tiempo por defecto de adjudicación: " def_lease
										read -p "Dime el tiempo máximo de adjudicación: " max_lease
										echo -e "subnet $di_red netmask $netmask {\n	range $init_ip $end_ip;\n	option domain-name-servers $ip_dns;\n	option domain-name $d_red;\n	option subnet-mask $netmask;\n	option routers $gateway;\n	option broadcast-address $broadcast;\n	default-lease-time $def_lease;\n	max-lease-time $max_lease;\n}" >> /etc/dhcp/dhcpd.conf
										cont=$(($cont + 1))
										clear
									done
						elif [ $opcion -eq 2 ]
							then
								clear
								echo "Realizando copia de seguridad para el archivo isc-dhcp-server...."
								sleep 2
								if [ $(find /etc/default/isc-dhcp-server 2>/dev/null | wc -l) -gt 0 ]
									then
										mv /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.copy
							 			echo "Realizando una copia de seguridad de el archivo dhcpd.conf ....."
								else
									echo "El archivo isc-dhcp-server no existe... Omitiendo la copia..."
								fi
								read -p "Dime la interfaz por la que se va a repartir ip (entre comillas): " interfaz
								echo "INTERFACESv4=$interfaz" > /etc/default/isc-dhcp-server
						elif [ $opcion -eq 3 ]
							then
								clear
								read -p "Dime el nombre de host: " n_host
								read -p "Dime la mac del host: " mac
								read -p "Dime la ip reservada: " ip_reserva
								echo -e "Host $n_host {\n   hardware ethernet $mac;\n   fixed-address $ip_reserva;\n}" >> /etc/dhcp/dhcpd.conf
						elif [ $opcion -eq 4 ]
							then
								clear
								echo "Realizando una copia de seguridad de el archivo dhcpd.conf...."
								sleep 2
								rm /etc/dhcp/dhcpd.conf
						elif [ $opcion -eq 5 ]
							then
								clear
								echo "reiniciando servicio....."
								sleep 3
								systemctl restart isc-dhcp-server
						elif [ $opcion -eq 6 ]
							then
								clear
								exit
						else
							echo "Opción no válida"
							sleep 3
						fi
				else
					echo "Introduce un número"
					sleep 3
				fi
			done
else
	echo "ERR:El escript sede ser ejecutado con sudo"
fi
