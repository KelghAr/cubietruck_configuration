import re, os, sys
regex = '^((?:(?!\.part\d+\.rar$).)*)\.(?:(?:part0*1\.)?rar)$'
extractDir = './extracted'
excludeDir = 'jj'
debugToCommandLine = True

mailmessage = """From: pyload@mail.andromeda.home
To: KelghAr <kelghar@mail.andromeda.home>
Subject: Extracting finished

"""

def find_all(regex, path):
	result = []
	comp = re.compile(regex, re.IGNORECASE)
	for root, dirs, files in os.walk(path):
		if excludeDir in dirs:
			dirs.remove(excludeDir)
		for file in files:
			if comp.match(file):
				result.append(os.path.join(root, file))
	log('Found ' + str(len(result)) + ' files', debugToCommandLine)
	return result


def send_to_trash(dir):
	from send2trash import send2trash
	log('Removing ' + dir, debugToCommandLine)
	# find *.r01 ect and remove
	fileWitoutEnding = os.path.splitext(os.path.basename(dir))[0]
	regexp = re.compile(r'part\d+\.')
	if regexp.search(dir) is None:
		regexp = re.compile(r'(rar|r\d+)$')
	else:
		# remove part1
		fileWitoutEnding = os.path.splitext(fileWitoutEnding)[0]
	for file in os.listdir(os.path.dirname(dir)):
		if regexp.search(file) is not None and fileWitoutEnding in file:
			fileToTrash = os.path.join(os.path.dirname(dir), file)
			log('Trashing file: ' + fileToTrash, debugToCommandLine)
			send2trash(fileToTrash)
	return

def extract(file, password):
	import subprocess
	cmd = ['7z', 'e', '-x!**/*.nfo', '-x!**/*sample*', '-o'+extractDir, '-p'+password, file, '-y']
	log('Command: ' + str(cmd), debugToCommandLine)
	child = subprocess.Popen(cmd, stderr=subprocess.STDOUT, stdout=subprocess.PIPE, bufsize=1)
	global mailmessage
	mailmessage = mailmessage + child.communicate()[0]
	returnval = child.returncode
	log('Returning ' + str(returnval), debugToCommandLine)
	return returnval

def getExtractSpaceRequirements(file, password):
	import subprocess
	import re
	cmd7z = ['7z', 'l', '-slt', '-p'+password, file]
	log('Command: ' + str(cmd7z), debugToCommandLine)
	ps7z = subprocess.Popen(cmd7z, stderr=subprocess.STDOUT, stdout=subprocess.PIPE, bufsize=1)
	output = ps7z.communicate()[0]
	if ps7z.returncode == 0:
		r = re.compile(r'^Size')
		grepLine = list(filter(r.match, output.decode('utf-8').splitlines()))
		cutLine = grepLine[0].split(' ')[2]
		log('Paket size: ' + cutLine, debugToCommandLine)
		return int(cutLine)
	return 0
	
def disk_usage(path):
    st = os.statvfs(path)
    free = st.f_bavail * st.f_frsize
    return free

def remove_empty_folders(path, removeRoot=True):
	if not os.path.isdir(path):
		log(path + ' is no dir!', debugToCommandLine)
		return

	# remove empty subfolders
	files = os.listdir(path)
	if len(files):
		for f in files:
			fullpath = os.path.join(path, f)
			if os.path.isdir(fullpath):
				remove_empty_folders(fullpath)

	# if folder empty, delete it
	files = os.listdir(path)
	if len(files) == 0 and removeRoot:
		log("Removing empty folder:" + path, debugToCommandLine)
		os.rmdir(path)

def main():
	if len(sys.argv) < 2:
		log("Please add password!")
		return
	password = sys.argv[1]
	files = find_all(regex, '.')
	for file in files:
		if getExtractSpaceRequirements(file, password) < disk_usage('.'):
			retval = extract(file, password)
			if retval == 0:
				send_to_trash(os.path.abspath(file))
			remove_empty_folders('.')
		else:
			log("Not enough space on disk.", debugToCommandLine)
	if not debugToCommandLine: sendMail()

def sendMail():
	import smtplib
	sender = 'pyload@mail.andromeda.home'
	receivers = ['kelghar@mail.andromeda.home']
	log("Sending Email...")
	try:
		smtpObj = smtplib.SMTP('mail.andromeda.home')
		smtpObj.sendmail(sender, receivers, mailmessage)
		log("Successfully sent email")
	except Exception as err:
		log("Error: unable to send email: {0}".format(err))

def log(message, print_commandline=True):
	import inspect
	logentry = 'LOG from ' + inspect.stack()[1][3] + ' : ' + message
	if print_commandline:
		print (logentry)
	else:
		global mailmessage
		mailmessage = mailmessage + logentry + '\n'

if __name__ == "__main__":
    main()
