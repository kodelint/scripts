#!/usr/bin/python
import sys
import os
import stashy

stash = stashy.connect("https://STASH-OR-BITBUCKET.example.com", "USERNAME", "PASSWORD")
for repo in stash.projects[sys.argv[1]].repos.list():
  for url in repo["links"]["clone"]:
    if (url["name"] == "ssh"):
      os.system("git clone %s" % url["href"])
      break


#NOTE: python clone_repo.py <<reponame>>
