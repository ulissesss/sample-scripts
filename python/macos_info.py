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
import socket
import subprocess
import platform
import sys

#@TODO: Step 0: TEST
#@TODO: Step 1: create functions (and function names) to clearly describe what work is being done
#@TODO: Step 2: Run those functions, collect the info into ___ format
#@TODO: Step 3: JSON


# For learning to preform tests ...

# def add_a_and_b_then_subtract_c(a, b, c):
#     '''
#     Function to explain unit testing
#     given a, b, and c, add a and b. then subtract c.
#     '''
#     return (a + b) - c


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
    ssid = [ item.strip() for item in subprocess.run(["/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport", "-I"], capture_output=True).stdout.decode().split("\n") ]
    return ssid

def get_os_version():
    os_version = subprocess.check_output(["sw_vers", "-productVersion"]).decode().strip()
    return os_version

def get_public_ip():
    ip = subprocess.check_output(["curl","-s","https://ipapi.co/ip/"]).decode().strip()
    return ip

def get_mac(ip):
    mac = subprocess.check_output(["arp",ip]).decode()
    return mac[mac.index(ip[-1]+")")+6:mac.index("on")-1]

def get_serial_number():
    proc1 = subprocess.Popen(['ioreg', '-l'], stdout=subprocess.PIPE)
    proc2 = subprocess.Popen(['grep', 'IOPlatformSerialNumber'], stdin=proc1.stdout,stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    proc1.stdout.close()
    out, err = proc2.communicate()
    return re.findall(r'"(.*?)"',out.decode())[1]

def main():
    with open(get_serial_number()+".csv","w") as f:
        f.write(f"""Uptime, " {get_uptime()}"
Username, {get_username()}
Computer Name,{get_computer_name()}
Ip,{get_ip_address()}
Public Ip,{get_public_ip()}
Mac,{get_mac(get_ip_address())}
OS Version,{get_os_version()}
""")
        for items in get_ssid():
            item = items.split(":")
            f.write(f'{item[0]},"{item[1]}"\n')
        f.close()

    print(get_computer_name())
    print(get_ip_address())
    print(get_public_ip())
    print(get_uptime())
    print(get_username())
    for x in get_ssid():
        print(x)
    print(get_os_version())
    print(get_mac(get_ip_address()))
    print(get_serial_number())
    # pass
    
if __name__ == '__main__':
    main()
