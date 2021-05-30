# AstarteNervesLedExample

This is a minimal working example for running an Astarte Device on any [Nerves supported
board](https://hexdocs.pm/nerves/targets.html#content).

Running this example you will be able to control and measure the state of your board-mounted LEDs by
sending and receiving data through [Astarte](https://github.com/astarte-platform/astarte).

## Prerequisites

For running this example you will need:
- a running [Astarte](https://github.com/astarte-platform/astarte) instance. You can have a look to
[Astarte in 5 minutes](https://docs.astarte-platform.org/1.0/010-astarte_in_5_minutes.html) to spin
up your local Astarte, or you can consider [Astarte Cloud](https://console.astarte.cloud/) to
interact with a hosted instance
- [astartectl](https://github.com/astarte-platform/astartectl) to interact with Astarte
- curl

## Setup the environment

Assuming you already created a realm, install the interfaces. You will find them in
`priv/interfaces`.
```
$ astartectl realm-management interfaces install
priv/interfaces/org.astarte-examples.LEDIndicator.json --realm-management-url <realm-management-url>
-r <realm> -k <realm-private-key>
$ astartectl realm-management interfaces install
priv/interfaces/org.astarte-examples.LEDCommand.json --realm-management-url <realm-management-url>
-r <realm> -k <realm-private-key>
```

Now register a new device. The outputs of this step will be used to set the environment for the
board.
```
$ astartectl pairing agent register <device-id> --pairing-url <pairing-url> -k <realm-private-key>
-r <realm>
```

You can generate a random valid `device-id` with
```
$ astartectl utils device-id generate-random
```

## Setup the board

The setup is targeted to the `rpi3` board. Change the config according to your needs.

Clone the project and get deps:
```
$ git clone git@github.com:matt-mazzucato/astarte_nerves_led_example.git
$ cd astarte_nerves_led_example
$ mix deps.get
```

Edit `samples/erlinit.config` file to set the values of the environment variables for your Astarte
device. Then, copy the file to `rootfs_overlay/etc`.

Now build the firmware:
```
$ export `MIX_TARGET=rpi3`
$ mix firmware
```

Put the SD card into the reader and flash the drive:
```
$ mix firmware.burn
```

Insert the SD into the board slot, power up the board and plug-in the ethernet cable. To check
that everything is working fine, find the IP of your board over the network and ssh into it. If you
can connect, check the logs with `RingLogger` to gather information about the device.

You can then push your updated firmware over the network with
```
$ mix firmware && ./upload.sh <device-address>
```

## Play with your LEDs

LEDs are controlled using `Nerves.Leds`. Find more information on its
[documentation](https://hexdocs.pm/nerves_leds/Nerves.Leds.html) page.

You can now send commands over an HTTP request to Astarte to control the state of your
LEDs.

Get your appengine token:
```
APPENGINE_TOKEN=$(astartectl utils gen-jwt appengine -k nerves_private.pem)
```

Turn on the `led0` of the `rpi3`:

```
$ curl -X POST -H "Authorization: Bearer $APPENGINE_TOKEN"
<appengine-url>/v1/<realm>/devices/<device-id>/interfaces/org.astarte-examples.LEDCommand/led0/turnOn
-H "Content-Type: application/json" -d '{"data": true}'
```

Once a command is received by the Astarte device, the message handler aknowledges its state. To
check the LED state just run:

```
$ curl -X GET -H "Authorization: Bearer $APPENGINE_TOKEN"
<appengine-url>/v1/<realm>/devices/<device-id>/interfaces/org.astarte-examples.LEDCommand/led0/turnedOn
-H "Content-Type: application/json"
```

Consider using Astarte Dashboard to explore your data if you prefer a graphical environment.
