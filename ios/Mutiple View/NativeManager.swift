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
        bundleManager!.goTo(view: rootViewController!, name: "hello")
    }
    @objc func openBundle(_ name:String, callback:RCTResponseSenderBlock){
        print(name)
        let rootViewController:UIViewController? = UIApplication.topViewController()
        let bundleManager:BundleManager? = BundleManager.getBundleManager()
        var appModel:AppModel? = bundleManager?.getAppModel()
        var appUpdateModel:AppUpdateModel? = bundleManager?.getAppUpdateModel()
        if ((appModel?.bundles[name]) != nil) {
            if appUpdateModel == nil {
                callback(["netError"])
            }else if appUpdateModel?.bundlesUpdate[name] != nil{
                callback(["update"])
            }else{
                bundleManager!.goTo(view: rootViewController!,name: name)
                
                
            }
        }else{
            callback(["new"])
        }
    }
    @objc func downloadAndOpenBundle(_ name:String,id:Int, callback:@escaping RCTResponseSenderBlock){
        print("---")
        print(id)
        let bunderManager:BundleManager? = BundleManager.getBundleManager()
        
        bunderManager!.downloadBundle(name: name, id:id, callback: callback)
        //        callback(["success"])
    }
    //    @objc func getToken(){
    //        let bunderManager:BundleManager? = BundleManager.getBundleManager()
    //        bunderManager!.getToken()
    //    }
    @objc func setToken(_ token:String){
        let bunderManager:BundleManager? = BundleManager.getBundleManager()
        bunderManager!.setToken(token: token)
    }
    
    @objc func getConfigData(_ resolver:RCTPromiseResolveBlock, rejecter:RCTPromiseRejectBlock){
        let bunderManager:BundleManager? = BundleManager.getBundleManager()
        let appModel:AppModel = (bunderManager?.getAppModel())!
        var events:NSArray = []
        let token:String = appModel.token!
        let serverUrl:String = appModel.url!
        let loginUrl:String = serverUrl.replacingOccurrences(of: "/mobileCloud/v1/bundle", with: "").replacingOccurrences(of: "gateway.", with: "")
        let appVetsionId:Int = appModel.id!
        events = [serverUrl,token,loginUrl,appVetsionId]
        resolver(events);
        
    }
    
    //下载图标
    @objc func downloadIcon(_ callback:@escaping RCTResponseSenderBlock){
        let bunderManager:BundleManager? = BundleManager.getBundleManager()
        bunderManager!.downloadIcon(callback:callback)
    }
    
    //加载本地模块
    @objc func getLocalData(_ callback:RCTResponseSenderBlock){
        let bunderManager:BundleManager? = BundleManager.getBundleManager()
        let appModel:AppModel = (bunderManager?.getAppModel())!
        var bundles:String = ""
        for bundleModel:BundleModel in appModel.bundles.values {
            let bundle = "{id:"+String(bundleModel.id!)+",name:"+bundleModel.name!
            bundles = bundles+bundle
        }
        
        print(bundles)
        callback([bundles])
    }
    
}

