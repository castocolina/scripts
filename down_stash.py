#!/usr/bin/python

import os, sys, getpass, subprocess
import urllib, urllib2, base64, json
import traceback
from os.path import expanduser

userHome = expanduser("~")
USR_DEF="_DEFAULT_"
SERVER_PORT=USR_DEF
#ids de proyectos separados por comas
STASH_PROJECTS=USR_DEF
GIT_CHECKOUT_PATH=USR_DEF
gUser=USR_DEF
gPasswd=USR_DEF


if SERVER_PORT == USR_DEF:
    SERVER_PORT = raw_input("COLOCAR IP:PUERTO = ").strip()

if STASH_PROJECTS == USR_DEF:
    STASH_PROJECTS = raw_input("LISTA DE PROYECTOS (separar con coma ',') = ").strip()

if GIT_CHECKOUT_PATH == USR_DEF:
    GIT_CHECKOUT_PATH = raw_input("RUTA CHECKOUT = ").strip();

if GIT_CHECKOUT_PATH == USR_DEF or GIT_CHECKOUT_PATH.strip() == '':
    GIT_CHECKOUT_PATH=userHome+"/git/stash"

print ("RUTA BASE::: " + GIT_CHECKOUT_PATH)

if gUser == USR_DEF:
    gUser = raw_input('git User: ')

if gPasswd == USR_DEF:
    if sys.stdin.isatty():
        gPasswd = getpass.getpass('git Password: ')
    else:
        gPasswd = raw_input('git Password: ')

## print '\n{}:{} '.format(gUser, gPasswd)

local_base64credentials = base64.b64encode('%s:%s' % (gUser, gPasswd))

k = 0
projects = STASH_PROJECTS.split(',')
for sProj in projects:
    k = k+1
    spName = sProj.strip()
    print("PROJECT.... {} - {}".format(k, spName))
    project_url = "http://{}/rest/api/1.0/projects/{}/repos".format(SERVER_PORT, spName)
    print("URL.... {}".format(project_url))
    try:
        params = urllib.urlencode({'limit' : 1000})

        request = urllib2.Request(project_url+"?"+params)
        request.add_header("Authorization", "Basic %s" % local_base64credentials)
        response = urllib2.urlopen(request)
        reposData = response.read();
        print("VALID === {}\n\n".format(response.getcode()))


        if not os.path.exists(GIT_CHECKOUT_PATH+"/"+spName):
            print ("CREATE ++ "+ GIT_CHECKOUT_PATH+"/"+spName)
            os.makedirs(GIT_CHECKOUT_PATH+"/"+spName)

    except Exception as ex:
        print "Unexpected error:", sys.exc_info()[0]
        print "Unexpected error:", ex
        traceback.print_exc(file=sys.stdout)
        exit(1)

    reposJson = json.loads(reposData)

    i = 0
    size = reposJson['size']
    for repoObj in reposJson['values']:
        i = i+1
        sname = repoObj['name'].encode('utf-8').strip()
        slug = repoObj['slug']
        strURLHttp = repoObj['cloneUrl']
        for sshCloneURL in repoObj['links']['clone']:
            if sshCloneURL['name'] == 'ssh':
                strURLSsh = sshCloneURL['href']
                break
        print (">>> P:{:>3} - R:{:>3}/{} \t {} - {} ".format(k, i, size, sname, slug))
        print ("SSH - {} ".format(strURLSsh))
        print ("HTTP - {} ".format(strURLHttp))
        print "-----------------------------------------------------------------------------"

        repoPath = GIT_CHECKOUT_PATH+"/"+spName+"/"+slug

        if os.path.exists(repoPath) and os.path.isdir(repoPath):
            print ('update ' + repoPath)
            subprocess.call(["git", "-C", repoPath, "pull", "--all", "--progress", "-v"])
        else:
            print ('clone at: ' + repoPath)
            subprocess.call(["git", "clone", "--progress", "-v", strURLSsh, repoPath])
            subprocess.call(["git", "-C", repoPath, "pull", "--all", "--progress", "-v"])


        print "*****************************************************************************\n"
