import configparser

config = configparser.ConfigParser()
config.read('/etc/samba/smb.conf')
config['global']['include'] = '/etc/samba/configs/smb_andromeda.conf'

with open('/etc/samba/smb.conf', 'w') as configfile:
    config.write(configfile)
