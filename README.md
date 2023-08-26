# nix-bmusb
A flake to build <Sesse's bmusb>(https://git.sesse.net/?p=bmusb;a=summary) for various target systems.

---

## bmusb's Readme:

bmusb is a free driver for BlackMagic's Intensity Shuttle and
UltraStudio SDI USB3 cards, which have no official Linux driver.
(The two seem to speak exactly the same protocol.) It runs in userspace
through usbfs, which may mean it could also probably run on FreeBSD,
but it's untested.

Current tested features (note, some of these are not exposed in the
driver except by changing the source code):

 * HDMI and SDI capture on a variety of modes including 720p60, 1080p30 and
   1080i60. 1080p60 is unfortunately not supported, despite earlier (now
   retracted) promises by Blackmagic that it would come in a future firmware
   revision (this is unlike the Thunderbolt versions, where some older firmware
   revisions _do_ support it).
 * 8-channel 24-bit 48 kHz locked audio capture.
 * Analog audio capture, including setting levels.
 * 8-bit 4:2:2 and 10-bit 4:2:2 capture.

The BlackMagic cards follow a protocol whose exact format is still
unknown, and the driver is still in beta stage. (The API/ABI is nearing
stability, but is still not really locked.)

It seems to want about 10â€“15% of one CPU core; a significant chunk of this is
copying data from the kernel over to userspace, which can be skipped by means
of zerocopy USB if you have a very recent libusb (>= 1.0.21) and a recent
kernel (>= 4.6.0). There's a decode step which also takes some time and memory
bandwidth, but it supports custom memory allocators, so that once the USB
packets are available to userspace, you can decode directly into e.g. pinned
GPU memory.

The driver itself lives in bmusb.cpp; main.cpp contains a very simple
client that just checks for frame continuity. It's recommended to run
as root or some other user that can run the USB thread at realtime
priority, as USB3 isochronous transfers are very timing sensitive.

The driver has been tested with various firmware versions; they seem to
behave mostly the same. There is currently no tool to upgrade or downgrade
the firmware on the card.

bmusb is Copyright 2015 Steinar H. Gunderson <steinar+bmusb@gunderson.no>
and licensed under the GNU General Public License, version 2, or at your
option, any later version. See the COPYING file.

---

##### footnote:
putting this flake out there under the same license, please fork and make better seeing as this is my first flake