  GazeCode (beta version)
  
  This software allows for fast and flexible manual classification of any
  mobile eye-tracking data. Currently Pupil Labs and Tobii Pro Glasses 2 data 
  are fully supported. The software loads an exported visualisation (video file) 
  and the data of a mobile eye-tracking measurement, runs a fixation
  detection algorithm (adaptation of Hooge and Camps, 2013, Frontiers in Psychology, 4,
  996) and offers a simple to use interface to browse through and
  categorise the detected fixations. This version is integrated with GlassesViewer to
  enable directly opening Tobii Pro Glasses 2 recordings as stored on the recording
  unit's SD card. As such, GlassesViewer needs to be available to GazeCode.
  The recommended way to make this work is to use the `git` tool to download GazeCode.
  Do as follows:
  1) install git from https://git-scm.org if you don't already have it. If you do not
     like using the command line/terminal, consider using a graphical git tool such as
     SmartGit, which is available free for non-commercial use

  2a) Download GazeCode and GlassesViewer in one go using the following command:
      `git clone --recurse-submodules -j8 git://github.com/foo/bar.git`
  2b) Should this not work due to your git version being too old, try executing the
      following commands:
      `git clone git://github.com/foo/bar.git`
      `cd GazeCode`
      `git submodule update --init --recursive`
  2c) If you prefer to download manually, first download GazeCode and GlassesViewer
      (available from https://github.com/dcnieho/GlassesViewer). The put the
      GlassesViewer directory inside your GazeCode directory is located (e.g.
      if `<rootdir>/../gazecode`, then `<rootdir>/../gazecode/GlassesViewer`).
  
  How to use:
  1) Place the GazeCode files in a directory to which you can easily navigate
  in Matlab
  
  2a) When using Pupil-labs data:
    1) Export both a visualisation video of raw mobile eye-tracking data and
       the data itself.

    2) Put the video file and the data file in the data folder of GazeCode
    (demo data are available at http://tinyurl.com/gazecodedemodata for Pupil-labs)

  2b) Tobii Pro Glasses 2 recordings as stored on its SD card can be directly
      loaded with GazeCode by making use of functionality provided by
      GlassesViewer.
     (demo data for Tobii Glasses are included in this repository)
  
  3) Find a set of nine 100 x 100 non-transparant PNGs reflecting the
  different categories you want to use (thenounproject.com is good place to
  start). Use white empty PNGs if you have less than 9 categories. Put
  these files in the categories folder of GazeCode.
  
  4) In Matlab set the working directory to the code folder of GazeCode and 
  type gazecode in the Matlab command window to start GazeCode.
  
  5) When prompted, point GazeCode to the category set, files and folders it
  requests.
  
  6) Browse through the detected fixations using the arrow buttons (or Z
  and X keys on the keyboard) in the left panel of GazeCode.
  
  7) Assign a category to a fixation by using the category buttons in the
  right panel of GazeCode or use (numpad) keyboard keys 1-9. Category
  buttons are numbered left-to-right, bottom-to-top (analogue to the
  keyboard numpad). Numpad 0 resets a category.
  
  8) Category codes of fixations can be exported to a file using the Save
  option in the menu of GazeCode.
  
  This open-source toolbox has been developed by J.S. Benjamins, R.S. Hessels 
  and I.T.C. Hooge. When you use it, please cite:
 
  Jeroen S. Benjamins, Roy S. Hessels, and Ignace T. C. Hooge. 2018. 
  Gazecode: open-source software for manual mapping of mobile eye-tracking 
  data. In Proceedings of the 2018 ACM Symposium on Eye Tracking Research & 
  Applications (ETRA '18). ACM, New York, NY, USA, Article 54, 4 pages. 
  DOI: https://doi.org/10.1145/3204493.3204568

  For importing data from Tobii Glasses 2, it uses GlassesViewer. When
  using this toolbox with Tobii Glasses data, please also cite 
  Niehorster, D.C., Hessels, R.S., and Benjamins, J.S. (in prep).
  GlassesViewer: Open-source software for viewing and analyzing data from
  the Tobii Pro Glasses 2 eye tracker.
 
  For more information, questions, or to check whether we have updated to a
  better version, e-mail: j.s.benjamins@uu.nl GazeCode is available from 
  www.github.com/jsbenjamins/gazecode and GlassesViewer from
  https://github.com/dcnieho/glassesviewer
 
  Most parts of GazeCode are licensed under the Creative Commons Attribution 
  4.0 (CC BY 4.0) license. Some functions are under MIT license, and some 
  may be under other licenses.
 
  Tested on:
  - Matlab 2014a, 2017a, 2018b on Mac OSX 10.10.5 and Max OSX 10.14.3
  - Matlab 2013a on Windows 7 Enterprise, Service Pack 1
  - Matlab 2016a, 2018a on Windows 10
