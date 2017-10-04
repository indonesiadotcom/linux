vsftpd without shell access

# Turn off anonymous users
anonymous_enable=NO
# Turn on local users
local_enable=YES
# Users should be able to write
write_enable=YES
# I don't give access to port 20 so turn this off 
connect_from_port_20=NO
# chroot everyone
chroot_local_user=YES
allow_writable_chroot=YES 

Disable shell access to ftp user:
Edit the file /etc/shells and add the line /bin/false:
echo "/bin/false" >> /etc/shells
Then change the shell of the user to /bin/false.
You can do this with command:
usermod ftpuser -s /bin/false
You can also restrict the commands that user can give. For example if you want only to upload/download files, and don't let people to delete files add this line:
cmds_allowed=PASV,BINARY,PUT,GET,PWD,STAT,TYPE,NLST,CWD,SIZE,MDTM,SITE,UTIME,REST,RETR,STOR,LIST,ASCII,RETR,QUIT

ref:
http://www.linuxexpert.ro/Linux-Tutorials/setup-vsftp-with-no-shell-access.html
https://www.benscobie.com/fixing-500-oops-vsftpd-refusing-to-run-with-writable-root-inside-chroot/
