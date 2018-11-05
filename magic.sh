apt-get install openssh-server -y
echo "Port 22" > /etc/ssh/sshd_config
echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config
echo "UsePAM yes" >> /etc/ssh/sshd_config
echo "X11Forwarding yes" >> /etc/ssh/sshd_config
echo "PrintMotd no" >> /etc/ssh/sshd_config
echo "AcceptEnv LANG LC_*" >> /etc/ssh/sshd_config
echo "Subsystem       sftp    /usr/lib/openssh/sftp-server" >> /etc/ssh/sshd_config
service ssh restart







