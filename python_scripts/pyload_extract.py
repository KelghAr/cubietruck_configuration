import re, os, sys
regex = '^((?:(?!\.part\d+\.rar$).)*)\.(?:(?:part0*1\.)?rar)$'
extractDir = './extracted'
password = '-'

mailmessage = """From: pyload@mail.andromeda.home
To: KelghAr <kelghar@mail.andromeda.home>
Subject: Extracting finished

"""

def find_all(regex, path):
	origin = 'find_all'
	result = []
	comp = re.compile(regex, re.IGNORECASE)
	for root, dirs, files in os.walk(path):
		if 'jj' in dirs:
			dirs.remove('jj')
		for file in files:
			if comp.match(file):
				result.append(os.path.join(root, file))
	log(origin, 'Found ' + str(len(result)) + ' files')
	return result


def send_to_trash(dir):
	from send2trash import send2trash
	origin = 'send_to_trash'
	log(origin, 'Removing ' + dir)
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
			log(origin, 'Trashing file: ' + fileToTrash)
			#send2trash(fileToTrash)
	return

def extract(file):
	import subprocess
	origin = 'extract'
	cmd = ['7z', 'e', '-x!**/*.nfo', '-x!**/*sample*', '-o'+extractDir, '-p'+password, file, '-y']
	log(origin, 'Command: ' + str(cmd))
	child = subprocess.Popen(cmd, stderr=subprocess.STDOUT, stdout=subprocess.PIPE, bufsize=1)
	global mailmessage
	mailmessage = mailmessage + child.communicate()[0]
	returnval = child.returncode
	log(origin, 'Returning ' + str(returnval))
	return returnval

def remove_empty_folders(path, removeRoot=True):
	origin = 'remove_empty_folders'
	if not os.path.isdir(path):
		log(origin, path + ' is no dir!')
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
		log(origin, "Removing empty folder:" + path)
		os.rmdir(path)

def main():
	import smtplib
	origin = 'main'
	sender = 'pyload@mail.andromeda.home'
	receivers = ['kelghar@mail.andromeda.home']
	if len(sys.argv) < 2:
		log(origin, "Please add password!", False)
		return
	global password
	password = sys.argv[1]
	files = find_all(regex, '.')
	for file in files:
		retval = extract(file)
		if retval == 0:
			send_to_trash(os.path.abspath(file))
	remove_empty_folders('.')
	print ("mailing")
	try:
		smtpObj = smtplib.SMTP('localhost')
		smtpObj.sendmail(sender, receivers, mailmessage)
		print ("Successfully sent email")
	except SMTPException:
		print ("Error: unable to send email")

def log(origin, message, print_commandline=True):
	if print_commandline:
		global mailmessage
		mailmessage = mailmessage + 'LOG from ' + origin + ' : ' + message + '\n'
	else:
		print ('LOG from ' + origin + ' : ' + message)

if __name__ == "__main__":
    main()
