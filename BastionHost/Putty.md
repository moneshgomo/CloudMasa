``` bash

monesh@GOMO:~$ ssh -i dev-key.pem ubuntu@3.238.225.236
The authenticity of host '3.238.225.236 (3.238.225.236)' can't be established.
ECDSA key fingerprint is SHA256:EDV59KFizYCOnqxIPtBRV0VGiogGEPElmAe+MGtbJs0.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '3.238.225.236' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 24.04.3 LTS (GNU/Linux 6.14.0-1018-aws x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Sat Mar  7 05:15:45 UTC 2026

  System load:  0.0               Temperature:           -273.1 C
  Usage of /:   25.9% of 6.71GB   Processes:             111
  Memory usage: 24%               Users logged in:       0
  Swap usage:   0%                IPv4 address for ens5: 172.31.73.108

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@ip-172-31-73-108:~$ exit
logout
Connection to 3.238.225.236 closed.
monesh@GOMO:~$ scp -i dev-key.pem li
linux_git/     live-key.pem
monesh@GOMO:~$ scp -i dev-key.pem live-key.pem ubuntu@3.238.225.236:/live-key.pem
scp: /live-key.pem: Permission denied
monesh@GOMO:~$ scp -i dev-key.pem live-key.pem ubuntu@3.238.225.236:~/live-key.pem
live-key.pem                                               100% 1674     5.4KB/s   00:00
monesh@GOMO:~$ ssh -i dev-key.pem ubuntu@3.238.225.236
Welcome to Ubuntu 24.04.3 LTS (GNU/Linux 6.14.0-1018-aws x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Sat Mar  7 05:19:10 UTC 2026

  System load:  0.0               Temperature:           -273.1 C
  Usage of /:   26.4% of 6.71GB   Processes:             112
  Memory usage: 24%               Users logged in:       0
  Swap usage:   0%                IPv4 address for ens5: 172.31.73.108


Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update

Last login: Sat Mar  7 05:15:46 2026 from 106.205.43.62
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@ip-172-31-73-108:~$ ls
live-key.pem
ubuntu@ip-172-31-73-108:~$ chmod 400 live-key.pem
ubuntu@ip-172-31-73-108:~$ ls -lstr
total 4
4 -r-------- 1 ubuntu ubuntu 1674 Mar  7 05:19 live-key.pem
ubuntu@ip-172-31-73-108:~$ ssh -i ~/live-key.pem ubuntu@172.31.72.111
The authenticity of host '172.31.72.111 (172.31.72.111)' can't be established.
ED25519 key fingerprint is SHA256:Em+xGDEhtvc9BsdYr/3OXhz6nUzP9wWXD57wVOnL910.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '172.31.72.111' (ED25519) to the list of known hosts.
Welcome to Ubuntu 24.04.3 LTS (GNU/Linux 6.14.0-1018-aws x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Sat Mar  7 05:20:46 UTC 2026

  System load:  0.0               Temperature:           -273.1 C
  Usage of /:   25.9% of 6.71GB   Processes:             109
  Memory usage: 24%               Users logged in:       0
  Swap usage:   0%                IPv4 address for ens5: 172.31.72.111

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@ip-172-31-72-111:~$ exit
logout
Connection to 172.31.72.111 closed.
ubuntu@ip-172-31-73-108:~$ mkdir -p ~/myapp
echo "<h1>Hello from Dev Server - version v1</h1>" > ~/myapp/index.html
cat ~/myapp/index.html
<h1>Hello from Dev Server - version v1</h1>
ubuntu@ip-172-31-73-108:~$ vim ~/deploy.sh
ubuntu@ip-172-31-73-108:~$ chmod +x ~/deploy.sh
./deploy.sh
🚀 Starting Deployment to Live Server...
─────────────────────────────────────────
sending incremental file list
created directory /home/ubuntu/myapp
./
index.html

sent 180 bytes  received 79 bytes  172.67 bytes/sec
total size is 44  speedup is 0.17
─────────────────────────────────────────
✅ Deployment Done!
ubuntu@ip-172-31-73-108:~$ ssh -i ~/live-key.pem ubuntu@172.31.72.111 "cat ~/myapp/index.html"
<h1>Hello from Dev Server - version v1</h1>
ubuntu@ip-172-31-73-108:~$ ls
deploy.sh  live-key.pem  myapp
ubuntu@ip-172-31-73-108:~$ echo "<h1>Hello from Dev Server - version v2</h1>" > ~/myapp/index.html
ubuntu@ip-172-31-73-108:~$ ./deploy.sh
🚀 Starting Deployment to Live Server...
─────────────────────────────────────────
sending incremental file list
index.html

sent 181 bytes  received 41 bytes  148.00 bytes/sec
total size is 44  speedup is 0.20
─────────────────────────────────────────
✅ Deployment Done!
ubuntu@ip-172-31-73-108:~$ ssh -i ~/live-key.pem ubuntu@172.31.72.111 "cat ~/myapp/index.html"
<h1>Hello from Dev Server - version v2</h1>
ubuntu@ip-172-31-73-108:~$



```
