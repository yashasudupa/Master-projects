# KAI external references bibliography

Please add only references that are not authored by KAI personnel.
KAI references are tracked in the git submodule `website-literature` [https://bitbucket.vih.infineon.com/projects/KAI/repos/website-literature].

For convenience, the acknowledgment texts for our funding projects are
available in the directory `acknowledgment`.


CONTRIBUTING
------------

In order to contribute to this repository, a few tools are required:

* Git (obviously)
* JabRef 4.3.1


In JabRef, import the jabref.prefs.xml settings and restart.

Now you can add entries to the `library.bib` file.
Please generate bib-keys and name PDF files according to the bib-key.
The link to the PDF files must include the `documents/` prefix.

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
