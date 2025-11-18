# hp3k_sim - HP3000 MPE V/E Simulator

- Version   : A.00.00
- Author    : Robert W.Mills
- Copyright : © Robert W.Mills [rwmills.uk@gmail.com], 2025-2025.
- Note      : This program comes with absolutely no warranty.
- License   : [GNU General Public License v3.0 or later](gnu.org/licenses/gpl-3.0.html)


## Description:

> **hp3k_sim** was designed to automate the configuration and execution of a SimH HP3000 MPE V/E Simulator.

> If the simulator is configured to enable conversion of Line Printer output to PDF then a process will be execute to perform this function. The look of the PDF emulates the iconic **Green Bar** continuous form paper that dominated the early computer age in several variants.

### Simulator Selection and Terminal Window Configuration

> This is a dialog box that displays the currently selected simulator along with the settings for the terminal window that the simulator will run in.

> It lets you select which of the available simulators will be executed. You can also adjust the width (columns), height (rows), 'location' of the terminal window and the text size used within the terminal window.

> Four buttons reside at the bottom of the dialog box.

>   * [About] will display a dialog box giving details about **hp3k_sim**.
  * [Help] will display a dialog box that gives additional information about the dialog box.
  * [Cancel] will terminate **hp3k_sim**.
  * [Continue] will either display the <u>Line Printer to PDF Convertor</u> dialog box (if enabled) OR open a terminal window where the selected simulator will be executed.

### Line Printer to PDF Convertor

> This is a dialog box that displays the convertor settings along with the settings for the terminal window that the convertor will run in.

> It lets you adjust where the Line Printer output is comming from, how many lines and the colour used for the alternating bars, where the PDF files will be written, and the font (type and size) that will be used. You can also adjust the width (columns), height (rows), 'location' of the terminal window and the text size used within the terminal window.

> Three buttons reside at the bottom of the dialog box.

>   * [Help] will display a dialog box that gives additional information about the dialog box.
  * [Cancel] will terminate **hp3k_sim**.
  * [Continue] will open two terminal windows. The first is where the simulator is executed and the second is where the convertor is executed.
