GazeCode (alpha version)

This software allows for fast and flexible manual classification of any
mobile eye-tracking data. Currently Pupil Labs and Tobii Pro Glasses data 
are supported. The software loads an exported visualisation (video file) 
and the data of a mobile eye-tracking measurement, runs a fixation
detection algorithm (Hooge and  Camps, 2013, Frontiers in Psychology, 4,
996) and offers a simple to use interface to browse through and
categorise the detected fixations.

How to use:
1) Place the GazeCode files in a directory to which you can easily navigate
in Matlab

2) Export both a visualisation video of raw mobile eye-tracking data and
the data itself. 
(demo data is available at http://tinyurl.com/gazecodedemodata)

3) Put the video file and the data file in the data folder of GazeCode

4) Find a set of nine 100 x 100 non-transparant PNGs reflecting the
different categories you want to use (thenounproject.com is good place to
start). Use white empty PNGs if you have less than 9 categories. Put
these files in the categories folder of GazeCode.

5) In Matlab set the working directory to the code folder of GazeCode and 
type gazecode in the Matlab command window to start GazeCode.

6) When prompted, point GazeCode to the category set, files and folders it
requests.

7) Browse through the detected fixations using the arrow buttons (or Z
and X keys on the keyboard) in the left panel of GazeCode.

8) Assign a category to a fixation by using the category buttons in the
right panel of GazeCode or use (numpad) keyboard keys 1-9. Category
buttons are numbered left-to-right, bottom-to-top (analogue to the
keyboard numpad).

9) Category codes of fixations can be exported to a file using the Save
option in the menu of GazeCode.

This open-source toolbox has been developed by J.S. Benjamins, R.S.
Hessels and I.T.C. Hooge. When you use it, please cite:

Jeroen S. Benjamins, Roy S. Hessels, and Ignace T. C. Hooge. 2018. Gazecode: open-source software for manual mapping of mobile eye-tracking data. In Proceedings of the 2018 ACM Symposium on Eye Tracking Research & Applications (ETRA '18). ACM, New York, NY, USA, Article 54, 4 pages. DOI: https://doi.org/10.1145/3204493.3204568

For more information, questions, or to check whether we have updated to a
better version, e-mail: j.s.benjamins@uu.nl 
GazeCode is available from www.github.com/jsbenjamins/gazecode

Most parts of  GazeCode are licensed under the Creative Commons
Attribution 4.0 (CC BY 4.0) license. Some functions are under MIT
license, and some may be under other licenses.

Tested on
- Matlab 2014a and 2017a on Mac OSX 10.10.5
- Matlab 2013a on Windows 7 Enterprise, Service Pack 1
- Matlab 2016a on Windows 10
