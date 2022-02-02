import UIKit
import Flutter
import PAYJP

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        PAYJPSDK.publicKey = "pk_test_0383a1b8f91e8a6e3ea0e2a9"
        PAYJPSDK.locale = Locale.current
        // ----- 追加するコードは、ここから
        let _controller = window?.rootViewController as! FlutterViewController
        let _channel = FlutterMethodChannel(
            name: "net.cbtdev.sample/method",
            binaryMessenger: _controller.binaryMessenger)
        
        _channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            switch(call.method) {
            case "hello":
                result("私は iOSs です")
                // 引数がある場合は call.arguments に入っています
                return
            case "pay":
                var test = ImportTest().test()
                
                result(test);
            default:
                result("No Method")
                return
            }
        })
        // ----- ここまで
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
