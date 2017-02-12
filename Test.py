#!/usr/bin/python
import optparse
import re
import socket
import sys
from signal import signal, SIGPIPE, SIG_DFL
signal(SIGPIPE,SIG_DFL)
import mechanize
import sys
import urllib2
import time
from random import randint


#########################################################################
# Program: <APPLICATION DESCRIPTION HERE>
#########################################################################
#########################################################################
# Copyright: <COPYRIGHT NOTICE HERE>
#########################################################################
__version__ =   "0.0.1" # <release>.<major change>.<minor change>
__prog__ =      "<APPLICATION NAME>"
__author__ =    "<YOUR NAME>"

#########################################################################
## Pipeline:
## TODO:
#########################################################################
class color:
   RED = '\033[91m'
   BOLD = '\033[1m'
   UNDERLINE = '\033[4m'
   END = '\033[0m'

#########################################################################
# XXX: Configuration
#########################################################################
br = mechanize.Browser()	#initiating the browser
br.addheaders = [('User-agent', 'Mozilla/5.0 (Windows; U; Windows NT 5.1; it; rv:1.8.1.11)Gecko/20071127 Firefox/2.0.0.11')]
br.set_handle_robots(False)
br.set_handle_refresh(False)

EXIT_CODES = {
	"ok"	  : 0,
	"generic" : 1,
	"invalid" : 3,
	"missing" : 5,
	"limit"   : 7,
}

#########################################################################
# XXX: Kick off
#########################################################################
regex = re.compile(("([a-z0-9!#$%&'*+\/=?^_'{|}~-]+(?:\.[a-z0-9!#$%&'*+\/=?^_'"
 "{|}~-]+)*(@|\sat\s)(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?(\.|"
 "\sdot\s))+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)"))

def initializeAndFind(firstDomains):

	dummy = 0	#dummy variable for doing nothing
	firstDomains = []	#list of domains
	if len(sys.argv) >=2:	#if the url has been passed or not
		url = sys.argv[1]
	else:
		print "Url not provided correctly"
		return 0

	smallurl = sys.argv[1]	#small url is the part of url without http and www

	allURLS = []
	allURLS.append(url)	#just one url at the moment
	largeNumberOfUrls = []	#in case one wants to do comprehensive search

	noSecondParameter = 0
	if len(sys.argv) < 3:
		noSecondParameter = 0
	else:
		noSecondParameter = 1
	if sys.argv[1]:
		print "Doing a short traversal."	#doing a short traversal if no command line argument is being passed
		for url in allURLS:
			x = str(url)
			smallurl = x
			url = "http://www." + str(url)
			try:
				br.open(url)
				print "Finding all the links of the website " + str(url)
				try:
					for link in br.links():		#finding the links of the website
						if smallurl in str(link.absolute_url):
							firstDomains.append(str(link.absolute_url))
					firstDomains = list(set(firstDomains))
				except:
					dummy = 0
			except:
				dummy = 0
		print "Number of links to test are: " + str(len(firstDomains))


def run():
    tarurl = FindDomains
    for line in tarurl:
        output = open("emails.txt", "a")
        time.sleep(randint(10,100))
        try:
            url = urllib.urlopen(line).read()
            output.write(line)
            emails = re.findall(regex, url)
            for email in emails:
                output.write(email[0]+"\r\n")
                print email[0]
        except:
            pass
            print "Error"

#########################################################################
# XXX: Helpers
#########################################################################

def debug(msg, override=False):
	if options.debug or override:
		print msg

def warn(msg):
	debug("[WARNING]: %s" % msg)
	sys.stderr.write("[WARNING]: %s\n" % msg)

def err(msg, level="generic"):
	if level.lower() not in EXIT_CODES:
		level = "generic"

	sys.stderr.write("[ERROR]: %s\n" % msg)
	sys.exit(EXIT_CODES[level])

#########################################################################
# XXX: Initialisation
#########################################################################

if __name__ == "__main__":
	parser = optparse.OptionParser(
                usage="Usage: %prog [OPTIONS]",
                version="%s: v%s (%s)" % (__prog__, __version__, __author__),
                description="<DESCRIPTION OF THE APPLICATION HERE>",
                epilog="Example: <EXAMPLE HERE>",
        )

        parser.add_option("-c", "--conf", default="config.conf", action="store", dest="config",
                help="Specify which config to use (default: config.conf)")

        parser.add_option('-o', '--output', default="STDOUT", dest="output",
                help='Specify the output file (default: STDOUT)')

        parser.add_option('-d', '--debug', action='store_true', dest="debug",
                help='Display verbose processing details (default: False)')

	parser.add_option('-v', action='version',
                help="Shows the current version number and exits")

        (options, args) = parser.parse_args()

	try:
		run()
	except KeyboardInterrupt:
		print "\n\nCancelled."
		sys.exit(0)
