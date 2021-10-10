(If you can't read this properly in Notepad, click Format -> Word Wrap above.)

This file contains instructions on how to use the project once it's been cloned to a local folder. If you don't know how to do that, go to https://github.com/athreyr/aircraft_design.


INTRODUCTION
------------
The reader is assumed to know basic concepts of Object Oriented Programming (OOP) like classes, properties, objects, methods, etc. If not, you can read about MATLAB-specific OOP at https://www.mathworks.com/help/matlab/object-oriented-programming.html.

In the folder in which this file exists (which we'll call the "root" from now), you will see the following (possibly in a different order) folders (terminated by '\') and files (other than this one you're reading):
* .git\ (hidden)
* @AtmosphericModel\
* @Unit\
* data\
* helper\
* internal\
* .gitattributes
* .gitignore
* CONTRIBUTING.md
* LICENSE.md
* README.md
* runMeFirst.m

Unless you wish to submit modifications to this code on the Github site, you only need to look at the following things:
* @AtmosphericModel\
* @Unit\
* data\
* helper\
* internal\
* runMeFirst.m (I'll come up with a better name in a future release)


DESCRIPTION
-----------
The folders whose names start with an '@' are called "class folders" and basically contains the definition and methods of the class of the same name. So, you can see that we have 2 classes in the root:
* AtmosphericModel, which is a template for reference atmospheres
* Unit, which is a template for a physical unit

These classes won't work without adding the helper\ (which contains reusable general-purpose functions) and internal\ (which contains functions specific to this project) folders to the MATLAB search path, which is taken care of by executing "runMeFirst" before using the project. (You can even add that to your startup file --make sure to include a cd to the root-- so you don't need to call it explicitly in every session.)

data\ contains, well, the data files, e.g. default values of arguments to class constructor, unit conversion information, etc.


OPERATION
---------
Once you have navigated to the project root folder in MATLAB, you can call the class methods (including the constructor) directly from a script or the Command Window. You can even add the entire root to MATLAB path and write functions that use it from any other folder.

You can view the internal documentation for a class 'Foo' by typing:
	doc Foo
in the Command Window. To view documentation for the class constructor instead, type:
	doc Foo.Foo
If it is a property or method 'bar' you need to see, type:
	doc Foo.bar

I have tried to explain everything in the internal documentation, but if you need any further help, go to https://github.com/athreyr/aircraft_design, click "Issues" -> "New issue", and describe what you need help with. (You might need to create a Github account for doing that, but (1) it's free, (2) they don't spam you, and (3) it'll help you do this with every project on Github, so no need to worry.)
