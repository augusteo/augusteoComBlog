+++
author = ""
date = "2016-10-04T19:46:30+11:00"
description = "Loads of new descriptions to write!"
tags = ["Tech"]
title = "iOS10 Crash - New Privacy Permission Settings and Descriptions"

+++

![](/blogFiles/crash-test-collision.jpeg)
So we were getting crashes on development build when our app tries to ask user for camera permission on iOS10. It hasn't happened on iOS9, and we didn't know what went wrong. Setting up exception breakpoint on throw and catch doesn't help either. Apple should really give us more clue on this. I was stuck for a while.

Until my team mate said that it might be the new privacy settings.

Lo and behold, he is right, turns out there are heaps of new privacy permission request description that we have to add now. Prior to iOS10, only location permission was required. The full list are:

```swift
NSBluetoothPeripheralUsageDescription
NSCalendarsUsageDescription
NSVoIPUsageDescription
NSCameraUsageDescription
NSContactsUsageDescription
NSHealthShareUsageDescription 
NSHealthUpdateUsageDescription
NSHomeKitUsageDescription
NSLocationUsageDescription
NSLocationAlwaysUsageDescription
NSLocationWhenInUseUsageDescription
NSAppleMusicUsageDescription
NSMicrophoneUsageDescription
NSMotionUsageDescription
NSPhotoLibraryUsageDescription
NSRemindersUsageDescription
NSSpeechRecognitionUsageDescription
NSSiriUsageDescription
NSVideoSubscriberAccountUsageDescription
```

In the case of our app, adding `NSCameraUsageDescription` into `info.plist` fix the crashes and display a description message under the `App would like to access your camera` system alert.
