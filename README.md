# ARMon

This is just a tiny demo showing how to display a 3D model in with AR.</br>
It does not push the system any further that that.

## How to test ?
Just run the app and scan one of those images to pop Eevee or Bulbasaur (you can print them for more fun)


<img src="https://github.com/Kireyin/ARMon/blob/master/armon/armon/Assets.xcassets/cards.arresourcegroup/Eevee.arreferenceimage/2f4913a0174ff40ddee9b2e9f65ac2fb.jpg" width="400" alt="Eevee"><img src="https://github.com/Kireyin/ARMon/blob/master/armon/armon/Assets.xcassets/cards.arresourcegroup/Bulbasaur.arreferenceimage/1633835-bulbasaur_by_thunderwest.jpg" width="400" alt="Bulbasaur">

## Limitations
This demo uses `ARWorldTrackingConfiguration` as the `ARSession` configuration and the Session is fed with a few Images to track.</br>
`ARWorldTrackingConfiguration` only allow to track a few Images at a time, and since we are feeding the collection of Images directly to the session, we end up behing abble to pop a limited number of pokemon species.</br>

A fun way to workaround this limitation would be to train an ML image recognition model that would output a pokemon name and an image when it recognize one, and dynamically load the Image to the session to be tracked. This would allow to pop any Pokemon, with the only limitaion to display a few at time.
