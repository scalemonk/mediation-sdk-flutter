import UIKit
import Flutter
import ScaleMonkAds

/*
 * @SMAds: this is relevant, here you will find the communication
 * with the SMAds SDK.
 */

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, SMRewardedVideoAdEventListener, SMInterstitialAdEventListener {
    
    var scaleMonkAds: SMAds? = nil
    var flutterChannel: FlutterMethodChannel?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        flutterChannel = FlutterMethodChannel(name: "scalemonk.com/ads",
                                                  binaryMessenger: controller.binaryMessenger)
        flutterChannel!.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            switch call.method {
            case "initializeSMAds":
                self?.initializeSMAds(result: result)
            case "showInterstitial":
                self?.showInterstitial(controller: controller)
            case "showBanner":
                self?.showBanner(controller: controller)
            case "showRewarded":
                self?.showRewarded(controller: controller)
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
        scaleMonkAds!.showInterstitialAd(viewController: controller, tag: "Main-Menu")
    }

    private func showBanner(controller: UIViewController) {
        /*
        * viewController: A `UIViewController` that is currently in the view hierarchy,
        * tag: An optional string value to know in which screen the ad was shown in. (For example: `Main-Menu`)
        */
        let bannerView = SMBannerView()
        // Here place your banner view where it should be positioned.
        // For the banner's size (width and height) use the size that
        // fits your needs best and we will try to fill it with the
        // biggest banner posible.
        bannerView.frame = CGRect(x: 0, y: 150, width: 320, height: 50)
        bannerView.viewController = controller
        controller.view.addSubview(bannerView)
        scaleMonkAds!.showBannerAd(viewController: controller, bannerView: bannerView, tag: "Main-Menu")
    }
    
    private func showRewarded(controller: UIViewController) {
        /*
        * viewController: A `UIViewController` that is currently in the view hierarchy,
        * tag: An optional string value to know in which screen the ad was shown in. (For example: `Main-Menu`)
        */
        scaleMonkAds!.showRewardedVideoAd(viewController: controller, tag: "Main-Menu")
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
                result(FlutterError(code: "ScaleMonk-ERROR",
                                    message: "Couldn't initialize SM Ads",
                                    details: nil))
            } else {
                result("success")
            }
        }
        
        scaleMonkAds?.addVideoListener(self)
        scaleMonkAds?.addInterstitialListener(self)
    }
   
// MARK: Rewarded Video and Interstitial Callbacks
    
    func onRewardedFinish(withReward tag: String!) {
        flutterChannel!.invokeMethod ("onRewardedFinish", arguments: nil);
    }
    
    func onRewardedFail(_ tag: String!) {
        flutterChannel!.invokeMethod ("onRewardedFail", arguments: nil);
    }
    
    func onRewardedFinishWithNoReward(_ tag: String!) {
        flutterChannel!.invokeMethod ("onRewardedFinishNoReward", arguments: nil);
    }
    
    func onInterstitialView(_ tag: String!) {
        flutterChannel!.invokeMethod ("onInterstitialView", arguments: nil);
    }
    
    func onInterstitialClick(_ tag: String!) {
        flutterChannel!.invokeMethod ("onInterstitialClick", arguments: nil);
    }
    
    func onInterstitialFail(_ tag: String!) {
        flutterChannel!.invokeMethod ("onInterstitialFail", arguments: nil);
    }
    
    func onRewardedClick(_ tag: String!) {
        flutterChannel!.invokeMethod ("onRewardedClick", arguments: nil);
    }
}
