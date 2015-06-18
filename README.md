# mScan
An open source code quality scanner for CFML

### About
mScan is an open source.. something.

I call it a code quality scanner, but that's just because the original idea was to create an easily extendable test-engine that made very few assumptions.

You can use it to write tests for any kind of file, in any kind of language.

It's completely target-agnostic, though it does default the target file extensions to .cfm and .cfc

It's threaded, so it's reasonably fast.

It does eat some RAM, so I recommend 500+ allotted to the webapp.

### Install
Drop into a root folder and start it up, done..

Ok, there are a couple of requirements: OpenBD and Windows, and a recommended 500+ mb of ram

I haven't tested it on any other engine, and the file-open assumes windows.

### Using

The GUI is pretty self-explanatory, but just in case:

####Path (Absolute path to folder or file)
Enter the absolute root folder of the files to scan.
An absolute path is the same as what-the-path-looks-like-in-explorer, so for example c:\myawesomecfmlproject is an absolute path.

####File extensions (Defaults to .cfc,.cfm)
Enter the file extensions you want to scan.

####Exclude paths (Absolute paths, one per line):
I'll be honest, this one's a bit dodgy, as it uses 'contains', that's why I tell you to enter a full path.
If you put the letter 'a', no file with a path that contains the letter 'a' will be scanned.

Enter one path per line, for example of you're root path is c:\myawesomecfmlproject, then maybe you want to exclude c:\myawesomecfmlproject\someone-elses-code\



Select the tests you want to run, hover them to display a short tooltip with info about each test, then hit the big button that says "Do the thing!" to do the thing.

After it runs (And it's threaded, so it's reasonably fast), you get back a list of files, and the errors in each file.

Clicking on the name of a file should open the file in your default editor if you're on a Windows machine.
