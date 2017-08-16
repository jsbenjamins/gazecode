GazeCode

This software allows for fast and flexible manual classification of any
mobile eye-tracking data. Currently Pupil Labs and Tobii Pro Glasses data 
are supported. The software loads an exported visualisation (video file) 
and the data of a mobile eye-tracking measurement, runs a fixation
detection algorithm (Hooge and  Camps, 2013, Froniters in Psychology, 4,
996) and offers a simple to use interface to browse through and
categorise the detected fixations.

How to use:
1) Export both a visualisation video of raw mobile eye-tracking data and
the data itself.

2) Put the exported video and data in the data folder of GazeCode

3) Find a set of nine 100 x 100 non-transparant PNGs reflecting the
different categories you want to use (thenounproject.com is good place to
start). Upload white empty PNGs if you have less than 9 categories. Put
these files in the categories folder of GazeCode.

4) Go to the code folder of GazeCode and in the Matlab command window
type 'gazecode' to start GazeCode.

5) Point GazeCode to the category set, files and folders it requests when
prompted.

6) Browse through the detected fixations using the arrow buttons (or Z
and X keys on the keyboard) in the left panel of GazeCode.

7) Assign a category to a fixation by using the category buttons in the
right panel of GazeCode or use (numpad) keyboard keys 1-9. Category
buttons are numbered left-to-right, bottom-to-top (analogue to the
keyboard numpad).

8) Category codes of fixations can be exported to a file using the Save
option in the menu of GazeCode.

This open-source toolbox has been developed by J.S. Benjamins, R.S.
Hessels and I.T.C. Hooge. Please cite as:
J.S. Benjamins, R.S. Hessels, I.T.C. Hooge (2017). GazeCode: an
open-source toolbox for mobile eye-tracking data analysis. Journal of Eye
Movement Research.

For more information, questions, or to check whether we have updated to a
better version, e-mail: j.s.benjamins@uu.nl 
GazeCode is available from ww.github.com/jsbenjamins/gazecode

Most parts of the GazeCode are licensed under the Creative Commons
Attribution 4.0 (CC BY 4.0) license. Some functions are under MIT
license, and some may be under other licenses.

Tested on Matlab 2014a.
