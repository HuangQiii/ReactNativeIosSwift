import Foundation
import UIKit
import React

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}


@objc(NativeManager)
class NativeManager: NSObject {
    @objc func testCall(){
        let rootViewController:UIViewController? = UIApplication.topViewController()
        let bundleManager:BundleManager? = BundleManager.getBundleManager()
        bundleManager!.goTo(view: rootViewController!,name: "Hello")
    }
    @objc func openBundle(_ name:String){
        let rootViewController:UIViewController? = UIApplication.topViewController()
        let bundleManager:BundleManager? = BundleManager.getBundleManager()
        bundleManager!.goTo(view: rootViewController!,name: name)
        print(name)
    }
    @objc func downloadBundle(_ name:String){
        let bunderManager:BundleManager? = BundleManager.getBundleManager()
        bunderManager!.downloadBundle(name: name, url: "http://xxx/v1/bundle/downFile/3/1")
    }
    @objc func getToken() -> String{
        let bunderManager:BundleManager? = BundleManager.getBundleManager()
        return bunderManager!.getToken()
    }
    @objc func setToken(_ token:String){
        let bunderManager:BundleManager? = BundleManager.getBundleManager()
        return bunderManager!.setToken(token: token)
    }
//    @objc func getConfigData(_ callback:RCTResponseSenderBlock){
//        callback(["HELLO"])
//    }
    @objc func getConfigData(_ resolver:RCTPromiseResolveBlock, rejecter:RCTPromiseRejectBlock){
        let bunderManager:BundleManager? = BundleManager.getBundleManager()
        let appModel:AppModel = (bunderManager?.getAppModel())!
        var events:NSArray = []
        let token:String = appModel.token!
        let serverUrl:String = appModel.url!
        let loginUrl:String = serverUrl.replacingOccurrences(of: "/mobileCloud/v1/bundle", with: "").replacingOccurrences(of: "gateway.", with: "")
        events = [serverUrl,token,loginUrl]
        resolver(events);
        
    }

}

