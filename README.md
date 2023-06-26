# PayloadMaster

PayloadMaster is a script that allows you to create various types of payloads and listeners for different operating systems. It leverages Metasploit Framework's msfvenom and msfconsole to generate and handle the payloads.

## Prerequisites

- Metasploit Framework: Make sure you have Metasploit Framework installed and set up on your system.

## Usage

1. Run the script using the following command:
   ```
   ./PayloadMaster.sh
   ```

2. Select an option from the menu to create a payload and listener for the desired target.

3. Follow the prompts to provide the necessary details such as payload name, LHOST, and LPORT.

4. If needed, configure the listener with different LHOST and LPORT.

5. The script will generate the payload file and start the listener using msfconsole.

6. Proceed with the instructions provided by the script and Metasploit Framework to exploit the target or test its vulnerability.

## Options

The script provides the following options:

1. **Windows**: Create Windows payload and listener.
2. **Android**: Create Android payload and listener.
3. **Linux**: Create Linux payload and listener.
4. **MacOS**: Create MacOS payload and listener.
5. **Web**: Create Web payload and listener.
6. **Scan if a target is vulnerable to ms17_010**: Perform an SMB vulnerability scan.
7. **Exploit Windows 7/2008 x64 ONLY by IP (ms17_010_eternalblue)**: Exploit Windows 7/2008 x64 systems using the EternalBlue exploit.
8. **Enable Remote Desktop (ms17_010_eternalblue)**: Enable Remote Desktop on exploited Windows 7/2008 x64 systems.
9. **Exploit Windows Vista/XP/2000/2003 ONLY by IP (ms17_010_psexec)**: Exploit Windows Vista/XP/2000/2003 systems using the PSEXEC exploit.
10. **Enable Remote Desktop (ms17_010_psexec)**: Enable Remote Desktop on exploited Windows Vista/XP/2000/2003 systems.
11. **Exploit Windows with a link (HTA Server)**: Exploit Windows systems using an HTA Server.
12. **Quit**: Quit the script.

## Disclaimer

This script is intended for educational and ethical purposes only. Use it responsibly and only on authorized systems.

