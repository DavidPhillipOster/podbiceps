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
* sometimes, I don't get a duration. Currently, show an 'indeterminate' symbol for the pie chart.'
* sometimes, I don't get artwork for some episodes. Cache artwork in RAM, and use that of another episode.
* icons and startup screens

TODO -
- notification handlers in player,
- library notification handlers in tableview.
- when the app starts and there's something already playing, then make sure the currently playing item is in the tableview.

- my sort

- Persistent 'stop' list. binary file? SQLite ?
- cache album artwork in my app's persistent storage, so I'll have fallback artwork.
- created 'amount played' icons at runtime (and cache them)
