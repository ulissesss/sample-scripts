#!/usr/local/bin/python3
import os, re, socket, subprocess,time

def get_computer_name():
    user_info = os.uname()
    computer_name = user_info[1]
    return computer_name


def get_ip_address():
    return socket.gethostbyname(socket.gethostname())


def get_uptime():
    return subprocess.check_output("uptime").decode().strip()


def get_username():
    return os.getlogin()


def get_ssid():
    proc1 = subprocess.Popen(
        ["/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport", "-I"], stdout=subprocess.PIPE)
    proc2 = subprocess.Popen(['grep', '-w', 'SSID'], stdin=proc1.stdout,
                             stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    proc1.stdout.close()
    out = proc2.communicate()
    return out[0].decode().split(":")[1].strip()


def get_os_version():
    os_version = subprocess.check_output(
        ["sw_vers", "-productVersion"]).decode().strip()
    return os_version


def get_public_ip():
    ip = subprocess.check_output(
        ["curl", "-s", "https://ipapi.co/ip/"]).decode().strip()
    return ip


def get_mac(ip):
    try:
        subprocess.run(f'ping {ip}', shell=True,timeout=1,capture_output=False)
        time.wait(1)
    except:
        pass

    mac = subprocess.check_output(["arp", ip]).decode()
    return mac[mac.index(ip[-1]+")")+6:mac.index("on")-1]


def get_serial_number():
    proc1 = subprocess.Popen(['ioreg', '-l'], stdout=subprocess.PIPE)
    proc2 = subprocess.Popen(['grep', 'IOPlatformSerialNumber'],
                             stdin=proc1.stdout, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    proc1.stdout.close()
    out = proc2.communicate()
    return str(re.findall(r'"(.*?)"', out[0].decode())[1])

EXPORT_DATA = f'''
Machine Name,   {get_computer_name()}
Ip Address,     {get_ip_address()}
Mac,            {get_mac(get_ip_address())}
Public Ip,      {get_public_ip()}
Uptime,        "{get_uptime()}"
Username,       {get_username()}
SSID,           {get_ssid()}
OS Version,     {get_os_version()}
'''

def main():
    with open(get_serial_number()+".csv", "w") as f:
        f.write(EXPORT_DATA)
        f.close()
    time.sleep(1)
    # print(EXPORT_DATA)

if __name__ == '__main__':
    main()
