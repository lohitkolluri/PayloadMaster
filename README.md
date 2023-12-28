# PayloadMaster

PayloadMaster is a bash script that streamlines the process of creating Metasploit payloads, setting up listeners for different platforms, scanning for MS17-010 vulnerabilities, and exploiting Windows targets using MS17-010 (EternalBlue).

## Prerequisites

- Metasploit Framework
- Bash shell (Linux and macOS)

## Usage

1. **Clone the repository:**

   ```bash
   git clone https://github.com/lohitkolluri/PayloadMaster.git
   ```

2. **Navigate to the script directory:**

   ```bash
   cd PayloadMaster
   ```

3. **Make the script executable:**

   ```bash
   chmod +x payloadmaster.sh
   ```

4. **Run the script:**

   ```bash
   ./payloadmaster.sh
   ```

5. **Follow the on-screen instructions to create payloads, scan for vulnerabilities, and exploit targets.**

## Features

- Supports Windows, Linux, and Android platforms.
- Allows you to choose the payload type based on the selected platform.
- Scans for MS17-010 vulnerabilities.
- Exploits Windows targets using MS17-010 (EternalBlue).
- Enables Remote Desktop on Windows targets using MS17-010.
- Creates payloads with a link (HTA Server).
