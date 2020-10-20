#!/usr/bin/env python3

bibFile = "tmp/all.bib"
try:
    fIn = open(bibFile, 'r', encoding="utf8")
except IOError as e:
    print("ERROR: Input bib file '" + bibFile +
          "' doesn't exist or is not readable")
    sys.exit(-1)

allAuthors = set()
authorDict = {}

for line in fIn:
	line = line.strip(" \n")
	if line.startswith("author") and "=" in line:
		value = line.split("=")[1].strip(" {},")
		authors = value.split(" and ")
		for author in authors:
			# convert to lastnames, firstnames format (sort by lastnames)
			if "," not in author:
				try:
					authorparts = author.split(" ")
					author = authorparts[-1] + ", " + " ".join(authorparts[0:-1])
				except IndexError as e:
					print("IndexError: " + author)
			allAuthors.add(author)
			if author not in authorDict:
				authorDict[author] = 1
			else:
				authorDict[author] += 1

for k, v in sorted(authorDict.items(), key=lambda kv: kv[1], reverse=True):
	print(k + ": " + str(v))
