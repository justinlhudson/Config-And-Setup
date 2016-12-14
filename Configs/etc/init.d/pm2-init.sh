### Notes:
#/etc/init.d/pm2-init.sh
# chown <username>:<username> /home/<username>/.pm2
# ??? chmod 755 -R /home/<username>/.pm2
# sudo env PATH=$PATH:/usr/bin pm2 startup ubuntu -u <username>
# pm2 start ecosystem.config.js
# pm2 save

# Edit:
NAME=pm2
PM2=/usr/local/bin/pm2
USER=<username>
DEFAULT=/etc/default/$NAME

export PM2_HOME="/home/$USER/.pm2"