if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi

export THE_HOME=$DATA_DIR/autocomplete
mkdir -p $THE_HOME
groupadd autocomplete
useradd -s /bin/bash -g autocomplete -d $THE_HOME autocomplete

cd $THE_HOME
git clone https://github.com/buda-base/autocomplete-prototype.git
cd autocomplete-prototype
pip3 install -r requirements.txt

chown -R scam:scam $THE_HOME

erb /vagrant/conf/autocomplete/systemd.erb > /etc/systemd/system/autocomplete.service

systemctl daemon-reload
systemctl enable scam
systemctl start scam