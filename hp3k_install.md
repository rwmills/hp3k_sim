# Install hp3k_sim for the HP3000 MPE V/E Simulator Utility

- Version A.00.00

- **These instructions only apply to Linux**.

- **No attempt has been tried with Windows** (the author does not have access to it). It ***may*** work if you have installed the WSL (Windows Subsystem for Linux). If you try it then please let me know how it went.

## Assumptions

- The HP3000 MPE V/E Simulators are installed in sub-directories within the **$HOME/HP3000/** directory.

> - [David Bryant's Series 58](https://simh.trailing-edge.com/hp/#Downloads) is installed in the **Series_58_DB/** sub-directory.

> - [Gavin Scott's Turnkey Big Series 58](https://drive.google.com/uc?export=download&id=1AFlELXfs6DIm2RHpBlI-6qSe0VxYBWzz) is installed in the **Series_58_GS/** sub-directory.

- There is a directory named **$HOME/bin/** where the executables are stored. It must be included in the **PATH** variable.

- There is a directory named **$HOME/bin/data/** where data files required by the executables are stored.

- There is an ***optional*** directory named **$HOME/bin/doc/** where the documentation can be stored.

## Required Software

- **yad (Yet Anathor Dialog)** is used to create the dialog boxes and should be available via your Software Manager. The latest version is available from [here](https://github.com/v1cont/yad).

- A modified/cutdown version of **elp2pdf** is used to convert the <u>Line Printer Output to PDF</u>. The original is available from [here](https://github.com/pascalgp/elp2pdf).

- **enscript** is used by **elp2pdf** in the file conversion process and should be available via your Software Manager. The latest version is available from [here](https://www.gnu.org/software/enscript/).

- **ghostscript (ps2pdf)** is used by **elp2pdf** in the file conversion process and should be available via your Software Manager. The latest version is available from [here](https://ghostscript.com/releases/index.html).

## Install Files

- Copy **hp3k_sim**, **elp2pdf.pl** and **elp-mpev.pl** to the **$HOME/bin/** directory.

- Copy **hp3k_sim.ini** and **hp3k_sim.jpg** to the **$HOME/bin/data/** directory.

- Copy **hp3k_sim.md** and **hp3k_install.md** (this file) to the **$HOME/bin/doc/** directory. <u>This is optional.</u>

- Copy **dot-enscryptrc** to the **$HOME/** directory and rename it to **.enscryptrc**.

- Edit **.enscriptrc** and replace **USER** in the **LibraryPath:** path with the user's name.

- Within the **$HOME/** directory create a hidden directory named **.enscript**.

- Copy **enscript.pro** to the **$HOME/.enscript** directory.

## Things you *might* need to change

> If you have any problems with the following then please raise an issue (GitHub/rwmills/hp3k_sim). I will answer as soon as possible.

> ### hp3k_sim

> Line 22 contains the path to the image file (hp3k_sim.jpg) that is displayed in the About dialog. It also used in place of the standard icon displayed by **yad** in the Task Bar (at the top or bottom of your screen) when a dialog box is active.

> Line 43 contains the path to the configuration file (hp3k_sim.ini).

> No other changes should be required. All configurations are controlled by data within **hp3k_sim.ini**.

> ### hp3k_sim.ini

> This is a Windows format INI file and matches my personal setup that supports four simulator configurations. The comments within the file should be clear enough to guide you making required changes except for the **x_coordinate** keys in the [simulator_window] and [convertor_window] sections.

>  My setup consists of two screens. The primary has a resolution of 1920 x 1080 and the secondary has a resolution of 1024 x 768. The secondary screen is positioned to the right of the primary with the top of both screens, configured within Linux, to be level. The **x_coordinate** for both the simulator and convertor terminal windows is set to 1920. This forces both of the terminal windows onto the secondary screen. This will need to changing if you do not have multiple screens.
