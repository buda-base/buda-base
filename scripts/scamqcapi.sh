if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi

export THE_HOME=$DATA_DIR/scam
mkdir -p $THE_HOME
groupadd scam
useradd -s /bin/bash -g scam -d $THE_HOME scam

cd $THE_HOME
git clone https://github.com/buda-base/scam.git
cd scam
pip3 install -r requirements.txt

chown -R scam:scam $THE_HOME

erb /vagrant/conf/scamqcapi/systemd.erb > /etc/systemd/system/scamqcapi.service

systemctl daemon-reload
systemctl enable scam
systemctl start scam