#!/usr/local/bin/python3
'''
Collect machine, OS data.
    computer name (nodename/name of machine on network)
    ip address
    uptime
    username
    ssid (name of wifi network)
    os
Export the data in JSON format.
    {
     machine name
     ip address
     uptime
     username
     ssid
     os
    }
'''

import os
import re
import socket
import subprocess
from time import sleep

def get_computer_name():
    '''
    https://docs.python.org/3/library/os.html#os.uname
    Returns information identifying the current operating system. The return value is an object with
    five attributes:
    sysname - operating system name
    nodename - name of machine on network (implementation-defined)
    release - operating system release
    version - operating system version
    machine - hardware identifier
    '''
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


def main():
    with open(get_serial_number()+".csv", "w") as f:
        f.write(f"""Uptime, " {get_uptime()}"
Username, {get_username()}
Computer Name,{get_computer_name()}
SSID,{get_ssid()}
Ip,{get_ip_address()}
Public Ip,{get_public_ip()}
Mac,{get_mac(get_ip_address())}
OS Version,{get_os_version()}
""")
        f.close()
    sleep(1)

    print("\n" + get_computer_name())
    print(get_ip_address())
    print(get_public_ip())
    print(get_uptime())
    print(get_username())
    print(get_ssid())
    print(get_os_version())
    print(get_mac(get_ip_address()))
    print(get_serial_number())
    # pass


if __name__ == '__main__':
    main()
