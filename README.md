# hp3k_sim - "HP3000 MPE V/E Simulator

<blockquote><pre>
Version   : A.00.00
Author    : Robert W.Mills
Copyright : © Robert W.Mills [rwmills.uk@gmail.com], 2025-2025.
Note      : This program comes with absolutely no warranty.
</pre></blockquote>
> License : [GNU General Public License v3.0](gnu.org/licenses/gpl-3.0.html)

## Description:

> Displays a dialog box where you can select which 'HP3000 Simulator' that you
> want to run from the drop-down list. Additional fields within the dialog box
> lets you adjust the height, width and location of the Terminal Window that
> the simulator is executed within.

> You then have the option to either **Continue** or **Cancel**.

> If you choose **Continue**, a second dialog box is displayed where you can amend
> the default settings of the 'Line Printer to PDF Convertor'. You can also
> adjust the height, width and location of the Terminal Window that the
> Converter is executed within.

>You then have the option to either **Continue** or **Cancel**.

>If you choose **Continue**, two Terminal Windows will be opened. The first will
> contain the Simulator Console (see Note 1 below) and the second will contain the
> Status Messages output by the Convertor.

> At this point the process will terminate as it's job has been completed.

## Warnings:

 1. If a print has been release for conversion to a PDF then DO NOT perform a Ctrl+A shutdown (MPE Console) until the convertor reports that it has finished (done) processing the file. If you do then the condition of the PDF is in doubt.

 2. The 'Line Printer to PDF Convertor' will automatically terminate when you exit the 'Simulator'. Any print that is currently being processed will be in a doubtfull condition. All subsequent prints that were released for converting will have been lost.

## Notes:

1. If you chose a simulator with the 'Dual Console' option then you will be
requested to connect a Terminal Emulator (Reflection, QCTerm, WS92, etc.), via
Telnet, to TCP Port 1045. The simulator will then redirect the 'MPE System
Console' to the Terminal Emulator.

2. This process uses a Windows Style INI File to hold the default values. The
INI file uses the same name as the script but has an '.ini' extension and must
reside in the same directory that holds the script. Please read the comments
within the INI File before making any changes.

3. The yad, elp2pdf, enscript and Ghostscript (ps2pdf) packages are required by
this script and must be installed for it to work.

> 3a. The dialog boxes are created with [yad (Yet Anathor Dialog)](github.com/v1cont/yad).

> 3b. The file conversion is done by [elpdf2](github.com/pascalgp/elp2pdf).

> 3c. The Windows format configuration file is accessed by the [Bash INI File Parser](github.com/tadgy/bash-ini-parser).