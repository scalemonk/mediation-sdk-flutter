import UIKit
import Flutter
import ScaleMonkAds

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var scaleMonkAds: SMAds? = nil
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let batteryChannel = FlutterMethodChannel(name: "samples.flutter.dev/battery",
                                                  binaryMessenger: controller.binaryMessenger)
        batteryChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            switch call.method {
            case "initializeSMAds":
                self?.initializeSMAds(result: result)
            case "showInterstitial":
                self?.showInterstitial(controller: controller)
            default:
                result(FlutterMethodNotImplemented)
                return
            }
        })
        
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func showInterstitial(controller: UIViewController) {
        /*
        * viewController: A `UIViewController` that is currently in the view hierarchy,
        * tag: An optional string value to know in which screen the ad was shown in. (For example: `Main-Menu`)
        */
        scaleMonkAds!.showInterstitialAd(with: controller, andTag: "Main-Menu")
    }

    
    private func initializeSMAds(result: @escaping FlutterResult) {
        scaleMonkAds = SMAds("sm-test-app-scalemonk-6407705726")! //replace with your application id

        /**
        This method initializes the SDK.
        - Parameters:
            - Callback is executed when the sdk finishes initializing with a value indicating success.
            - Note: Make sure to call this and wait for the callback block before calling any other method.
        */
        scaleMonkAds!.initialize { success in
            if !success {
                result(FlutterError(code: "CODE-VAZ",
                                    message: "Couldn't initialize SM Ads",
                                    details: nil))
            } else {
                result(Int(100))
            }
        }
    }
    
}
