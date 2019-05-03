# Etterna

<p align="center">
    <img src="CMake/CPack/Windows/etterna_arrow.svg" width="250px">
</p>

<p align=center>
    <a href="https://travis-ci.org/etternagame/etterna"><img src="https://img.shields.io/travis/etternagame/etterna.svg?label=travis"/></a>
    <a href="https://ci.appveyor.com/project/Nickito12/etterna"><img src="https://img.shields.io/appveyor/ci/Nickito12/etterna.svg?label=appveyor"/></a>
    <a href="https://scan.coverity.com/projects/etternagame-etterna"><img src="https://img.shields.io/coverity/scan/12978.svg"/></a>
    <a href="https://github.com/etternagame/etterna/releases"><img src="https://img.shields.io/github/downloads/etternagame/etterna/total.svg?label=total%20downloads"/></a>
    <a href="https://github.com/etternagame/etterna/releases"><img src="https://img.shields.io/github/downloads/etternagame/etterna/latest/total.svg?label=latest%20downloads"/></a>
    <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue.svg?label=license"/></a>
</p>

<p align="center">
    <a href="https://discord.gg/etternaonline"><img src="https://img.shields.io/discord/339597420239519755.svg?color=7289DA&label=Etterna%20Community&logo=Discord"/></a>
    <a href="https://discord.gg/ZqpUjsJ"><img src="https://img.shields.io/discord/261758887152058368.svg?color=7289DA&label=Etterna%20Dev%20Group&logo=Discord"/></a>
</p>

Etterna is a cross-platform rhythm game similar to [Dance Dance Revolution](https://en.wikipedia.org/wiki/Dance_Dance_Revolution). It started as a fork of [StepMania 5](https://github.com/stepmania/stepmania) (v5.0.12), with a focus on keyboard players. Over time, Etterna evolved into its own game, with in-game multiplayer, the online scoreboard [Etterna Online](https://etternaonline.com/), and a community of over 4,000 players.

## Table of Contents

- [Installing](#Installing)
  - [Windows and macOS](#Windows-and-macOS)
  - [Linux](#Linux)
- [Building](#Building)
- [Documentation](#Documentation)
- [Bug Reporting](#Bug-Reporting)
- [Contributing](#Contributing)
- [License](#License)

## Installing

### Windows and macOS

Head to the [Github Releases](https://github.com/etternagame/etterna/releases) page, and download the relevant file for your operating system. For Windows, run the installer, and you should be ready to go. For macOS, mount the DMG and copy the Etterna folder to a location of your choice. Run the executable, and you are ready to go.

### macOS

macOS has protection software called Gatekeeper. It ensures only trusted applications (code-signed apps) can be run on your system. Since we are an open-source project, we don't have the means to code-sign Etterna. If you have any trouble when opening Etterna on your system, please try to control-click the app, choose Open from the menu, and in the dialog that appears, click Open. Enter your admin name and password when prompted, and it should allow you to run the game.

### Linux

Currently, the only supported way to play Etterna on a Linux based operating system is to install from source. Please follow the instructions in [Building](Docs/Building.md) to get started.

## Building

All details related to building are in the [Building.md](Docs/Building.md) file. Since Etterna is cross-platform, you should be able to build on any recent version of Windows, macOS, or Linux.

## Documentation

Etterna uses Doxygen and LuaDoc. Both still need a lot of work before being having decent coverage, though we still have them hosted at the following links.  

- Latest C++ documentation: [https://etternagame.github.io/cpp-docs/](https://etternagame.github.io/cpp-docs/)
- Latest Lua documentation: [https://etternagame.github.io/lua-docs/](https://etternagame.github.io/lua-docs/)

## Bug Reporting

We use Github's [issue tracker](https://github.com/etternagame/etterna/issues) for all faults found in the game. If you would like to report a bug, please click the `Issues` tab at the top of this page, and use the `Bug report` template.

## Contributing

If you want to contribute to the Etterna client, please read [Building](Docs/Building.md) for instructions on how to get started. We have a variety of different tasks which would help the development of this game as a whole, all of which we have listed at [Contributing.md](Docs/Contributing.md) of If you are more interested in helping with the in-game multiplayer, the nodejs server, along with its documentation, is hosted [here](https://github.com/etternagame/NodeMultiEtt). You will still need the Etterna client built and running on your system. If there is something else you want to work on that we don't have listed here, feel free to [join EDG](), our development discord, and let us know what you want to add. The developers and contributors there would be able to give you a hand as to where you could start doing what you want to do.  

## License

Etterna uses the MIT License, as is required since we are derivative of StepMania 5. See [LICENSE](LICENSE) for more details.

In short, you are free to modify, sell, distribute, and sublicense this project. We ask that you include a reference to this github repository in your derivative, and do not hold us liable when something breaks.

Etterna uses the [MAD library](http://www.underbit.com/products/mad/) and [FFMPEG codecs](https://www.ffmpeg.org/). Those libraries, when built, use the [GPL license](http://www.gnu.org).