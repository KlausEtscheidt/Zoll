## @package config
# Konfigurationsparameter und globale Variable

import os
import getpass
import socket
import logging

loglevel = logging.DEBUG
#loglevel = logging.INFO

## zu durchsuchende LW
#home_dirs = ("G:\\", "W:\\", "Y:\\")
home_dirs = ("T:\\actress", "T:\\clip", "T:\\cpl", "E:\\")
#home_dirs += ("C:\\Users\\Klaus Etscheidt\\Documents\\python\\vdb\\",)

office_dirs = ("K:\\chk\\","D:\\chk\\")

## Startknoten fuer dir-tree
base_dir = {'/':'/',
            'd:to check clip': r'd:\chk\to check\clip',
            'd:to check cpl': r'd:\chk\to check\cpl\uncut',
            'd:to go back': r'd:\chk\to go back\clip',
            'd:is back': r'd:\chk\xx is back\clip',
            'e:dl_serie': r'e:\dl\_serie',
            'e:actress': r'e:\dl\_actr',
            'e:cpl': r'e:\dl\_cpl',
            't:/actress': r't:\actress',
            't:/clip/dl serie': r't:\clip\dl serie',
            't:/clip/label': r't:\clip\label',
            't:/clip/topic': r't:\clip\topic',
            't:/clip/serie': r't:\clip\serien',
            't:/cpl': r't:\cpl'
           }


## Benutzer
i_am = getpass.getuser()
#print('user: ', i_am)
my_host = socket.gethostname()
#print('host: ', my_host)

##Pfade
# Basis-Verzeichnis
my_file = os.path.realpath(__file__) # Welcher File wird gerade durchlaufen
my_dir = os.path.dirname(my_file)

##Datei die Befehle zum Manipulieren von Files (rename) erhaelt
batch_cmd_file = os.path.join(my_dir, 'repair', '_disk_edit_cmds_online.vdb')
cmd_file_writer = None

#Hauptframe, wird vom Hauptprogramm gefüllt
mainframe = None

#Datenbank
my_db_name = 'p.sqlite'
my_db_gdrive_id = '1_oJYQ3N8Mgql430FMRkcyVSuT1SBY_d7' #Id von p.sqlite auf google drive
my_db = os.path.join(my_dir, 'db', my_db_name)

#Datei mit Sql-Statements
sql_statements = os.path.join(my_dir, 'listen_u_hilfen', 'sql_sammlung.txt')

#ffmpeg + vlc
vlc = r'C:\Program Files\VideoLAN\VLC\vlc.exe'

if i_am == 'Etscheidt':
    ffmpeg_dir = r'K:\prog\ffmpeg\bin'
    vlc = r'C:\Program Files\VLC Plus Player\vlc.exe'
elif i_am == 'Klaus':
    ffmpeg_dir = r'W:\x_drops\ffmpeg_win32\bin'
elif i_am == 'Klaus Etscheidt':
    browser = r'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'
    ffmpeg_dir = r'C:\Users\Klaus Etscheidt\Documents\prog\ffmpeg\bin'
# if i_am == 'Klaus' and my_dir == r'\nas\jdown\vdb':
#     ffmpeg_dir = r'C:\Users\Klaus\Documents\progs\ffmpeg\bin'
# if i_am == 'Klaus' and my_dir == r'E:\vdb':
if my_host == 'Nucki':
    browser = r'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'
    ffmpeg_dir = r'C:\Users\Klaus\Documents\progs\ffmpeg\bin'
if my_host == 'Lenni':
    ffmpeg_dir = r'C:\Program Files\ffmpeg\bin'
    vlc = r'C:\Program Files\VLC Plus Player\vlc.exe'

#ffmpeg-Aufruf-Historie (übergeordnet)
ffmpeg_call_history = os.path.join(my_dir, 'logs', "ffmpeg_call_history.log")
#ffmpeg Logfiles (Detailausgabe einzelner Läufe)
ffmpeg_log_dir = os.path.join(my_dir, 'logs', 'sublogs')

#Datei zum Speichern von FFMpeg-Sonderabläufen
ffmpeg_statements = os.path.join(my_dir, 'listen_u_hilfen', 'ffmpeg_sammlung.txt')

#Datei zum Speichern von Metadaten (Titel, Kapitel, usw)
metadata_file = os.path.join(my_dir, 'resize_data', "_metadata.tmp")

#Datei mit resize Dateiliste
resize_jobliste = os.path.join(my_dir, 'resize_data', "_resize_jobliste.txt")
resize_jobliste_log = os.path.join(my_dir, 'resize_data', "_resize_erledigt.txt")
resize_jobliste_fflog = os.path.join(my_dir, 'resize_data', "_resize_ffmpeg.log")

#Liste der Files zum concatenate
files2concat = os.path.join(my_dir, 'resize_data', "myfiles.txt")

#Job-Argument-Liste
job_args = []

#Zeiten für cutting
cut_data = {}

#Statuszeile im GUI-mode setzen
gui_mode = False
def Status(msg):
    if gui_mode:
        mainframe.SetStatusText(msg)
    else:
        print(msg)

# Sollen fuer FFMpeg-Aufrufe Sonderparameter erfragt werden ?
ffmpeg_standard = True

# Sollen alle Files des Filepanels bearbeitet werden ?
work_on_filelist = False

#merke einen File
stored_file = None
#merke Zielverzeichnis
targetdir_path = None
