  # GazeCode (beta version)
  
  This software allows for fast and flexible manual classification of any
  mobile eye-tracking data. Currently Pupil Labs, SMI, Positive Science and Tobii Pro Glasses 2 data 
  are supported. The software loads an exported visualisation (video file) 
  and the data of a mobile eye-tracking measurement, runs a fixation
  detection algorithm (adaptation of Hooge and Camps, 2013, Frontiers in Psychology, 4,
  996) and offers a simple to use interface to browse through and
  categorise the detected fixations. This version is integrated with
  [GlassesViewer](https://github.com/dcnieho/GlassesViewer) to
  enable directly opening Tobii Pro Glasses 2 recordings as stored on the recording
  unit's SD card (no visualisation export needed). As such, GlassesViewer needs to be available to GazeCode.
  The recommended way to make this work is to use the `git` tool to download GazeCode.
  Alternatively you can download GazeCode's components separately and place them in the
  right locations. Here are instructions for these two routes:
  
  Before you download anything, GazeCode and GlassesViewer run in Matlab. Make sure Matlab is installed.
  
  We know our software works with:
  - Matlab 2017a, 2018b on Mac OSX 10.10.5, 10.14.3, and 10.14.6
  - Matlab 2016a, 2018a, and 2019b on Windows 10
  
  (other combinations will probably work as well, but have not been tested).
  
  1. Using Git
      1. install git from https://git-scm.org if you don't already have it. If you do not
       like using the command line/terminal, consider using a graphical git tool such as
       SmartGit, which is available free for non-commercial use
      1. Download GazeCode and GlassesViewer in one go using the following command:
      `git clone --recurse-submodules -j8 git://github.com/jsbenjamins/gazecode.git`
      1. Should this not work due to your git version being too old, try executing the
       following commands:
       ```
       git clone git://github.com/jsbenjamins/gazecode.git
       cd gazecode
       git submodule update --init --recursive
       ```
       If you have already cloned Titta but do not have the MatlabWebSocket submodule populated yet,
       issuing the `git submodule update --init --recursive` command will take care of that.
  1. Manual download:
      1. First download GazeCode and place it, unzipped if necessary, in your preferred folder.
      1. Then download GlassesViewer (available from https://github.com/dcnieho/GlassesViewer).
      1. Put the GlassesViewer directory inside GazeCode at the right location:
      `<GazeCode_RootDir>/GlassesViewer`).
  
  How to use:
  1) Place the GazeCode files in a directory to which you can easily navigate
  in Matlab
  
  2) Prepare the data you want to analyze:
      1. When using Pupil-labs, SMI or Positive Science data:
          1. If needed, export both a visualisation video of raw mobile eye-tracking data and
       the data itself.
          1. Put the video file and the data file in the data folder of GazeCode
    (demo data are available at http://tinyurl.com/gazecodedemodata for Pupil-labs, SMI and Positive Science)

      1. Tobii Pro Glasses 2 recordings as stored on its SD card can be directly
      loaded with GazeCode by making use of functionality provided by
      [GlassesViewer](https://github.com/dcnieho/GlassesViewer).
     (demo data for Tobii Glasses are included in this repository)
         1. [GlassesViewer](https://github.com/dcnieho/GlassesViewer) allows to
         manually label events in the eye-tracking data or other data streams
         provided by the Tobii Pro Glasses 2 to be coded manually, or for algorithmic
         coding to be manually adjusted. GlassesViewer can also be used to simply
         view the labeled events. One of these labeled events can then be selected
         when opening a recording in GazeCode. See [GlassesViewer's
         manual](https://github.com/dcnieho/GlassesViewer/blob/master/manual.md) for
         the complete workflow.
  
  3) Find a set of nine 100 x 100 non-transparant PNGs (images) reflecting the
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
 
  [Jeroen S. Benjamins, Roy S. Hessels, and Ignace T. C. Hooge. 2018. 
  Gazecode: open-source software for manual mapping of mobile eye-tracking 
  data. Proceedings of the 2018 ACM Symposium on Eye Tracking Research & 
  Applications (ETRA '18). ACM, New York, NY, USA, Article 54. DOI: 10.1145/3204493.3204568](https://doi.org/10.1145/3204493.3204568)

  For importing data from Tobii Glasses 2, it uses
  [GlassesViewer](https://github.com/dcnieho/GlassesViewer). When
  using this toolbox with Tobii Glasses data, please also cite 
  [Niehorster, D.C., Hessels, R.S., and Benjamins, J.S. (2020).
  GlassesViewer: Open-source software for viewing and analyzing data from
  the Tobii Pro Glasses 2 eye tracker. Behavior Research Methods. doi:
  10.3758/s13428-019-01314-1](https://link.springer.com/article/10.3758/s13428-019-01314-1)
 
  For more information, questions, or to check whether we have updated to a
  better version, e-mail: j.s.benjamins@uu.nl GazeCode is available from 
  www.github.com/jsbenjamins/gazecode and GlassesViewer from
  https://github.com/dcnieho/glassesviewer
 
  Most parts of GazeCode are licensed under the Creative Commons Attribution 
  4.0 (CC BY 4.0) license. Some functions are under MIT license, and some 
  may be under other licenses.
