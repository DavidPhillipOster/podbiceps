To install this on your device, you'll need to edit the bundle identifier. change 'com.turbozen' to the prefix you registered with Apple.

11/15/2014 - I built a podcast app that uses the iPhone's library of podcasts
I can reorder them, and play them, although the app doesn't yet go from one to the next.

played/unplayed/partially played/

See AddMusic in Downloads for more things to take care of to get this right.

11/20/2014 -
* when one ends, go to the next.
* if I'm already playing and I go to another by tapping, then it should start playing.
* beginnings of my sort

11/21/2014 - I finally read https://developer.apple.com/library/ios/documentation/Audio/Conceptual/iPodLibraryAccess_Guide/Introduction/Introduction.html
* album artwork
* remote player event notification, but I don't seem to be receiving using the switch on the headphones. In the car, I continue to get the same bad behavior: the begin seeking forward infinite loops, and seems unstoppable.

11/22/2014
* show how much of a podcast has been played in the tableview.
* sometimes, I don't get a duration. Currently, show an 'indeterminate' symbol for the pie chart.
* sometimes, I don't get artwork for some episodes. Cache artwork in RAM, and use that of another episode.
* More work on receiving remoteEvents.
* connect to library and player notifications.
11/23/2014
* persistent order, bookmark times, delete
11/24/2014
* Convert PodPersist's deleted from array to set in RAM, while leaving it an array on disk.
11/30/2014
* a MPMediaItem's url and podcast properties are useless.
* Override UIApplication sendEvent to examine all events. Are any of the remoteControl events? No.
* Keep track of which episodes I've played, when. (no U.I.)
12/06/2014
* receiving core motion data.

NEXT -
peripheral logging
peripheral graphing
simply wiring it up and trying it.

TODO -
- undo manager. undo labels.
- when the app starts and there's something already playing, then make sure the currently playing item is in the tableview.
- Keep track of which episodes I've played, when. (U.I.)

- my sort

- current item should be a superpositon of pie chart and 'speaker'
- bug: After turning editing off, I saw a cell with editing still on. After re-ordering, there was a blank cell.
- have a deleted items controller where the user can inspect, and possibly undelete items.



LESSONS LEARNED - 
You can't write a dictionary to disk if the keys are numbers, because the plist format only supports string keys.

Still can't figure out how to get RemoteControlPlay etc. events.

BUG -
animatedImageWithImages is incompatible with templateMode.