# SendHapticSwift
A sample Microsoft Band Kit SDK project in Swift that sends a haptic (vibration) to the paired band.

## Dependencies
* Uses the Microsoft Band Kit (MSB) for iOS (included). You can get the latest version from: http://developer.microsoftband.com/
* Demonstrates use of MSB with Swift. Written with Swift 1.2 and Xcode 6.3 Beta.
* Requires a Microsoft Band paired with your iPhone (there is no simulator, you need a physical band).

## Using
* Download, build and run.

## Authors
* Mark Thistle, http://droolfactory.blogspot.com

## About the Code
I have wrapped the MSB classes with a BandManager class to reduce some boilerplate as I write apps with MSB.  The BandManager is demonstrated being used to connect and then send a haptic to the band.
