import Foundation
import UIKit

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
}

