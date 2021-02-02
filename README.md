# Flutter sample app for ScaleMonk SDK

This is an -almost- empty Flutter application which minimalisticaly integrates the ScaleMonk SDK allowing to (a) initailise it and (b) show interstitials. 

This application follows:
 - [Flutter guide for iOS development](https://flutter.dev/docs/get-started/flutter-for/ios-devs)
 - [ScaleMonk integration guide for iOS](https://scalemonk.github.io/mediation-docs/#/mediation-sdk-ios/getting-started)

## Requirements
This application is known to run correctly on:
 - SMAds `0.1.1-alpha.4` 
 - Flutter `1.22.6`
 - Xcode `12.4`
 - Cocoapods `1.10.1`

## Important
- You have to correctly setup your credentials (applicationId) and setup the test mode on https://mediation.scalemonk.com
- Simulator might fail to correctly display ads (audio or video issues), if you encounter issues displaying ads on it try to use a real device.

## iOS: building & running
- After cloning the repository run `pod install --project-directory=ios` on the root folder of the project
- You have to follow normal practices for code signing for the project to run on an iOS device
- To run the project you can also use `flutter run`
