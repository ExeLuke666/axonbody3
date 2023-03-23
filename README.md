<h2 align="center">FiveM Axon Body 3</h2>

<p align="center">
<a href="https://patreon.com/yeen"><img alt="Patreon" src="https://img.shields.io/badge/patreon-donate?color=F77F6F&labelColor=F96854&logo=patreon&logoColor=ffffff"></a>
<a href="https://discord.gg/xHaPKfSDtu"><img alt="Discord" src="https://img.shields.io/discord/463778631551025187?color=7389D8&labelColor=6A7EC2&logo=discord&logoColor=ffffff"></a>
</p>

## Table of Contents

- [About](#about)
- [Installation](#installation)
- [Features](#features)
- [Configuration](#configuration)
- [Screenshots](#screenshots)
- [Contributing](#contributing)
- [Credits & Copyright](#credits--copyright)

## About

The most realistic Axon Body 3 script, based on [Axon Body Camera](https://forum.cfx.re/t/realistic-axon-body-camera/1155758).  
![img](https://i.imgur.com/Kzf8WpA.png "Real AB3 overlay")  
![img](https://i.imgur.com/1QQ5LmF.png "This script")  

Image 1: a real AB3 overlay  
Image 2: this script  

TFNRP’s Axon Body 3 script’s goal is to be as realistic as possible, with future plans for more audio files the real Axon Body 3 uses.  

## Installation

Clone from Git or download manually  

```sh-session
git clone https://github.com/TFNRP/axonbody3.git
```

To be able to use AB3, implement the `ab3.user.toggle` ace in your server config.  

> **Note**: If you don't need ACL checks, you may disable this ace by setting `CommandAccessAce` to `nil`, and implement the client-side logic in `CommandAccessHandling`.

## Features

- Supports the [TFNRP framework](https://github.com/TFNRP/framework) to allow use for LEO.  
- Just like the real thing. Beeps every 2 minutes whilst recording, **audible to nearby players**.  
- Realistic overlay, with the same font used by Axon, ISO-8601 date format and transparent Axon logo.
- Maximum server performance. Everything that can be done client-side, is.
- Two commands included:  
  - `/axon`, `/axonon`, `/axonoff` - Starts/stops Axon recording
  - `/axonhide`, `/axonshow` - Hide/show the first-person overlay

## Configuration

The `config.lua` is shared between the client and server.  
Config variables are explained in greater detail in `config.lua`, but here's an overview.

> **Warning**  
> Do not enter server secrets in `config.lua`.

property | type | description
-- | -- | --
`CommandBinding` = `'u'` | string\|nil | Keybind to use for on/off command. May be nil for no keybind  
`ThirdPersonMode` = `false` | boolean | Whether the axon overlay is also visible in third person  
||
`CommandAccessHandling` | function | Handling used to verify if the client should be able to enable AB3  
`CommandAccessAce` = `'ab3'` | string\|nil | Use ACL to determine whether the client should be able to enable AB3  
`ThrottleServerEvents` = `false` | boolean | Whether server events should be throttled server-side  
`ThrottleDropPlayer` = `true` | boolean | Whether the player should be dropped if the throttle is violated

## Screenshots

![img](https://i.imgur.com/mGZXo3l.png)

## Contributing

Please read [Contributing](https://github.com/TFNRP/axonbody3/blob/main/CONTRIBUTING.md) before submitting a pull request.

## Credits & Copyright

- [@RCPisAwesome](https://forum.cfx.re/u/RCPisAwesome) for
  - their [Axon Body Camera](https://github.com/RCPisAwesome/FiveMRCPAxonCamera) script; and
  - providing and giving permission of use of `static/beep.wav` file.

Licensed under [MIT License](https://github.com/TFNRP/axonbody3/blob/main/LICENSE).
