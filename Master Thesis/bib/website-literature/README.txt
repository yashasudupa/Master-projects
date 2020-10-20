# KAI external references bibliography

Please add only references that are authored by KAI personnel.
Non-KAI references are tracked in the git project `bib` [https://bitbucket.vih.infineon.com/projects/KAI/repos/bib].

CONTRIBUTING
------------

In order to contribute to this repository, a few tools are required:

* Git (obviously)
* JabRef 4.3.1


In JabRef, import the jabref.prefs.xml settings and restart.

Now you can add entries to the `*.bib` files corresponding to the year of the publication.
Please generate bib-keys following the format described in the jabref settings file.

* Do not add PDF file links into the bibtex entry
* You may add file links to the refbase

Example
~~~~
@MastersThesis{Berens2018,
  author    = {Berens, Judith},
  title     = {Cryogenic characterization of {4H}-{SiC} high power {MOSFET}},
  school    = {{RWTH Aachen University}},
  year      = {2018},
  address   = {Aachen},
  file      = {:https\://kai.intra.infineon.com/refbase/documents/Berens/1054_2018.pdf:URL},
  timestamp = {2018-04-19},
}
~~~~

When you are unsure, execute the `run-tests.sh` script (see below).

### In order to publish your entries, use BitBucket pull requests:

```sh
$ git co -b <new_branch_name>
$ git add <your_changes>
$ git commit
$ git push
```

This will upload your patch to BitBucket and also trigger an automated test with Jenkins.

You will also see a message similar to:

```
$ git push
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Delta compression using up to 4 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 1.28 KiB | 1.28 MiB/s, done.
Total 3 (delta 2), reused 0 (delta 0)
remote:
remote: View pull request for nb-steinweb => master:
remote:   https://bitbucket.vih.infineon.com/projects/KAI/repos/bib/pull-requests/6
remote:
To ssh://bitbucket.vih.infineon.com:7999/kai/bib.git
   38ead2b..e299ef6  nb-steinweb -> nb-steinweb
```

Copy/paste the pull-request link to you favorite browser and create a pull-request.
Once the test has successfully completed, your patch can be merged with the master branch.

### How to fix test failures:

When the Jenkins test fails, you will get an e-mail with some more or less
descriptive error message. Most of the issues can be resolved by saving the
file with JabRef with the settings imported (don't forget that).

You can manually run the test-suite on your machine by executing: (Python 3 required)

```sh
$ ./run-tests.sh
```
