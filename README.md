# Teensy 4.X Project Template

Template repo for Teensy 4.0, using Makefiles, and Arduino/Teensyduino stdlib.

Geared toward my own MacOS environment, YMMV. (Linux udev rules not included, etc.)

`Makefile` based on [apmorton's teensy-template](https://github.com/apmorton/teensy-template), which is derived from the PJRC teensy3 [core Makefile](https://github.com/PaulStoffregen/cores/blob/master/teensy3/Makefile) under it's [MIT-like license](https://github.com/PaulStoffregen/cores/blob/master/teensy3/Makefile#L1-L28)

## Using

* Project code lives in `src/`
* Libraries live under `libraries/`
* Top section of `Makefile` has some options, including: output executable name, location of `Teensyduino.app`, an option to use [ccache](https://ccache.dev/) if installed, clock speed of Teensy CPU for over/under clocking, and GCC optimization flag settings.
  * This `Makefile` relies on a local copy of Teensyduino
  * This `Makefile` also relies on a local copy `teensy_loader_cli`

`make` to compile code

`make upload` to upload to a connected Teensy
