import Foundation
import React
import SSZipArchive
import HandyJSON
import Alamofire


class BundleManager{
    
    static var bundleManager:BundleManager? = nil
    var bundleVersion:String? = nil
    
    static func getBundleManager() -> BundleManager {
        if BundleManager.bundleManager == nil {
            bundleManager = BundleManager()
        }
        return bundleManager!
    }
    
    static var secondView:SecondViewController? = nil
    static var viewController:ViewController? = nil

    
    func test(){
        
    }
    
    func goTo(view:UIViewController,name:String){
        if type(of:view) == ViewController.classForCoder() {
        //BundleManager.viewController?.dismiss(animated: true, completion: nil)
        //view.navigationController?.popViewController(animated: true)
            //主线程运行
            DispatchQueue.main.async {
                view.performSegue(withIdentifier: "ShowSecond", sender: name)
            }
        }else{
            view.performSegue(withIdentifier: "show2", sender: name)
        }
    
    }
    
    //下载bundle
    func downloadBundle(name:String, id:Int, callback:@escaping RCTResponseSenderBlock){
        
        let appModel:AppModel = getAppModel()!
        let destination: DownloadRequest.DownloadFileDestination = { _, response in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(name+"/"+name+".ios.zip")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        let token:String? = getAppModel()?.token

        let headers:HTTPHeaders=["Authorization":token!]
        let url = appModel.url!+"/downFile/"+String(describing: appModel.id!)+"/"+String(describing: id)
        var size:String?
        
        //print(url)
        Alamofire.download(url,headers:headers,to: destination)
            .response { response in
//                print("----------------")
//                print(response)
//                print((response.response?.statusCode)!)
                if((response.response?.statusCode)! == 200){
                    print(response.response?.allHeaderFields["Content-Disposition"])
                    let str:String = String(describing: (response.response?.allHeaderFields["Content-Disposition"])!)
                    let range1 = str.range(of: "-")
                    let range2 = str.range(of: ".zip")
                    let version = str.substring(with: (range1?.upperBound)!..<(range2?.lowerBound)!)
                    self.bundleVersion = version
                    print(version)
                    size = String(describing: response.response?.allHeaderFields["Content-Size"])
                }else{
                    callback(["failed"])
                }
            }
            .downloadProgress { progress in
                print("当前进度: \(progress.fractionCompleted)")
                print("已下载：\(progress.completedUnitCount/1024)KB")
                print("总大小:\(progress.totalUnitCount/1024)KB")
            }
            .responseData { response in
                if((response.response?.statusCode)! == 200){
                    if let data = response.result.value {
                        let homeDirectory:String = NSHomeDirectory()+"/Documents"
                        let mydir:String = homeDirectory+"/"+name
                        
                        let filePath:String = mydir + "/"+name+".ios.zip"
                        //print(filePath)
                        //                    print(mydir)
                        SSZipArchive.unzipFile(atPath: filePath, toDestination: mydir)//unzip
                        self.updateBundleSuccess(bundleId: id, name: name, version: self.bundleVersion!, bundleFile: "")
                        print("bundle下载解压完毕!")
                        callback(["success"])
                    }
                }else{
                    callback(["failed"])
                }
            }
    }
    //下载成功更新bundle.json和bundleupdate.json
    func updateBundleSuccess(bundleId:Int, name:String, version:String, bundleFile:String){
        var appModel:AppModel = getAppModel()!
        var appUpdateModel:AppUpdateModel = getAppUpdateModel()!
        
        var appModelChange:Bool = false
        var appUpdateModelChange:Bool = false
        
        if(appModel.mainBundle?.name == name){
            appUpdateModel.mainBundleUpdate = nil
            appModel.mainBundle?.id = bundleId
            appModel.mainBundle?.currentVersion = version
            appModel.mainBundle?.path = bundleFile
            appModelChange = true
            appUpdateModelChange = true
        } else {
            if(appUpdateModel.bundlesUpdate[name] != nil){
                appUpdateModel.bundlesUpdate[name] = nil
                appUpdateModelChange = true
            }
            if(appModel.bundles[name] != nil){
                appModel.bundles[name]?.id = bundleId
                appModel.bundles[name]?.currentVersion = version
                appModel.bundles[name]?.path = bundleFile
                appModelChange = true
            }else{
                var bundleModel:BundleModel = BundleModel()
                bundleModel.id = bundleId
                bundleModel.currentVersion = version
                bundleModel.name = name
                bundleModel.path = bundleFile
                appModel.bundles[name] = bundleModel
                appModelChange = true
            }
        }
        if(appModelChange){
            writeAppModel(appModel: appModel);
        }
        if(appUpdateModelChange){
            writeAppUpdateModel(appUpdateModel: appUpdateModel);
        }
    }
    //下载icon
    func downloadIcon() -> String{
        let appModel:AppModel = self.getAppModel()!
        var iconPath:String? = nil
        let destination: DownloadRequest.DownloadFileDestination = { _, response in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("icon/icon.zip")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        let token:String? = getAppModel()?.token

        let headers:HTTPHeaders=["Authorization":token!]
        let url:String? = appModel.url!+"/getBundleFileList/"+String(describing: appModel.id!)
        let homeDirectory:String = NSHomeDirectory()+"/Documents"
        let mydir:String = homeDirectory+"/icon"
        iconPath = mydir
        let filePath:String = mydir + "/icon.zip"
        Alamofire.download(url!,headers:headers,to: destination)
            .downloadProgress { progress in
                print("当前进度: \(progress.fractionCompleted)")
            }
            .responseData { response in
                if let data = response.result.value {
                    print("图标下载完毕!")
                    //解压到当前目录下
                    
                    SSZipArchive.unzipFile(atPath: filePath, toDestination: mydir)//unzip
                }
        }
        return iconPath!
    }
    //secondviewcontroller打开bundle
    func loadBundle(view: SecondViewController,name:String){
        let mydir:String = NSHomeDirectory()+"/Documents"
        let filePath:String = mydir + "/"+name+"/"+name+".ios.jsbundle"
        let jsCodeUrl:URL?=URL(fileURLWithPath: filePath)
        let mockData:NSDictionary = ["scores":
            [
                ["name":"1", "value":"1"],
                ["name":"2", "value":"2"]
            ]
        ]
        
        let rootView = RCTRootView(
            bundleURL: jsCodeUrl,
            moduleName: "Mutiple-View",
            initialProperties: mockData as [NSObject : AnyObject],
            launchOptions: nil
        )
        let vc = BundleManager.secondView
        vc?.view = rootView
        //view.present(vc, animated: true, completion: nil)
        view.navigationController?.pushViewController(vc!, animated: true)
    }
    func loadMainBundle(view: ViewController,name:String){
        let mydir:String = NSHomeDirectory()+"/Documents"
        let filePath:String = mydir + "/index/"+name+".ios.jsbundle"
        let jsCodeUrl:URL?=URL(fileURLWithPath: filePath)
        let rootView = RCTRootView(
            bundleURL: jsCodeUrl,
            moduleName: "Mutiple-View",
            initialProperties: nil,
            launchOptions: nil
        )
        let vc = BundleManager.viewController
        vc?.view = rootView
        //view.present(vc, animated: true, completion: nil)
        view.navigationController?.pushViewController(vc!, animated: true)
    }

    //------------------------modify
    //初始化复制json和index，并根据json的bundle去复制压缩包
    func syncBundleConfig(){
        copyBundleJson()
        copyAssetsBundle(name: "index")
        let appModel:AppModel=getAppModel()!
        let appModelBundles=appModel.bundles
        if(appModelBundles.count>0){
            for name:String in appModelBundles.keys {
                copyAssetsBundle(name:name)
            }
        }
        checkBundleConfigUpdate()
    }
    //复制配置表
    func copyBundleJson(){
        let fileManager = FileManager.default
        let mydir:String = NSHomeDirectory()+"/Documents"
        //print(NSHomeDirectory())
        let filePathOfBundle:String = mydir+"/bundleModel.json"
        let existOfBundlePlist = fileManager.fileExists(atPath: filePathOfBundle)
        let jsCodeStrOfBundlePlist = Bundle.main.path(forResource: "bundleModel", ofType: "json")
        
        if (!existOfBundlePlist && jsCodeStrOfBundlePlist != nil){
            do {
                try fileManager.copyItem(atPath: jsCodeStrOfBundlePlist!,toPath: filePathOfBundle)
            }catch let error as NSError {
                print("copy bundle json went wrong: \(error)")
            }
        }
    }
    //发送bundle检查是否更新，更新updatebundle
    func checkBundleConfigUpdate(){
        let bundleConfig=getAppModel()?.toJSON()
        let appModel:AppModel? = getAppModel()
        let token:String? = getAppModel()?.token

        let headers:HTTPHeaders = [
            "Content-Type":"application/json",
            "Authorization":token!
        ]
        
        Alamofire.request((appModel?.url)!+"/checkBundle", method: HTTPMethod.post, parameters: bundleConfig, encoding: JSONEncoding.default, headers:headers)
            .responseJSON{
                response in
                let json = response.result.value
                let data : Data! = try? JSONSerialization.data(withJSONObject: json!, options: [])
                let str = String(data:data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                let appUpdateModel:AppUpdateModel? = AppUpdateModel.deserialize(from: str)
                self.writeAppUpdateModel(appUpdateModel: appUpdateModel!)
        }
    }
    //复制bundle的压缩包
    func copyAssetsBundle(name:String){
        let fileManager = FileManager.default
        
        let homeDirectory:String = NSHomeDirectory()+"/Documents"
        let mydir:String = homeDirectory+"/"+name
        try! fileManager.createDirectory(atPath: mydir, withIntermediateDirectories: true, attributes: nil)//创建目录
        
        let filePath:String = mydir + "/"+name+".ios.zip"
        let exist = fileManager.fileExists(atPath: filePath)//判断是否存在
        let jsCodeStr = Bundle.main.path(forResource: name+".ios", ofType: "zip")
        
        if (!exist && jsCodeStr != nil){//不存在复制并解压
            do {
                try fileManager.copyItem(atPath: jsCodeStr!,toPath: filePath)//copy
                SSZipArchive.unzipFile(atPath: filePath, toDestination: mydir)//unzip
                copyIconByName(name: name)
            }
            catch let error as NSError {
                print("copy assets bundele went wrong: \(error)")
            }
        }
    }
    //复制name的icon到icon目录
    func copyIconByName(name:String){
        let fileManager = FileManager.default
        
        let homeDirectory:String = NSHomeDirectory()+"/Documents"
        let mydir:String = homeDirectory+"/icon"
        try! fileManager.createDirectory(atPath: mydir, withIntermediateDirectories: true, attributes: nil)//创建目录
        
        let filePath:String = mydir+"/"+name+".png"
        let exist = fileManager.fileExists(atPath: filePath)//判断是否存在
        let jsCodeStr = homeDirectory+"/"+name+"/"+name+".png"
        
        if !exist{//不存在复制并解压
            do {
                try fileManager.copyItem(atPath: jsCodeStr,toPath: filePath)//copy
            }
            catch let error as NSError {
                print("copy assets bundele went wrong: \(error)")
            }
        }
    }
    //读取配置表生成对象
    func getAppModel() -> AppModel?{
        let mydir:String = NSHomeDirectory()+"/Documents"
        
        let filePathOfBundle:String? = mydir+"/bundleModel.json"
        let ur = URL(fileURLWithPath: filePathOfBundle!)
        do {
            let str = try String(contentsOf: ur,encoding: .utf8)
            let appModel:AppModel = AppModel.deserialize(from:str)!
            return appModel
        } catch let error as NSError {
            print("Something went wrong: \(error)")
        }
        return AppModel()
        //.deserialize(from: "")
    }
    //写入配置表
    func writeAppModel(appModel:AppModel){
        do {
            let mydir:String = NSHomeDirectory()+"/Documents"
            let filePathOfBundle:String? = mydir+"/bundleModel.json"
            
            let str = appModel.toJSONString(prettyPrint: true)
            do {
                try str?.write(toFile: filePathOfBundle!, atomically: true, encoding: .utf8)
            } catch {
            }
        }
    }
    //读取更新表生成对象
    func getAppUpdateModel() -> AppUpdateModel?{
        let mydir:String = NSHomeDirectory()+"/Documents"
        
        let filePathOfBundle:String? = mydir+"/bundleUpdateModel.json"
        let ur = URL(fileURLWithPath: filePathOfBundle!)
        do {
            let str = try String(contentsOf: ur,encoding: .utf8)
            let appUpdateModel:AppUpdateModel = AppUpdateModel.deserialize(from:str)!
            return appUpdateModel
        } catch let error as NSError {
            print("Something went wrong: \(error)")
        }
        return AppUpdateModel()
    }
    //写入更新表
    func writeAppUpdateModel(appUpdateModel:AppUpdateModel){
        do {
            let fileManager=FileManager.default
            let mydir:String = NSHomeDirectory()+"/Documents"
            let filePathOfBundle:String? = mydir+"/bundleUpdateModel.json"
            let existOfBundlePlist = fileManager.fileExists(atPath: filePathOfBundle!)
            if !existOfBundlePlist{
                fileManager.createFile(atPath: filePathOfBundle!, contents: nil, attributes: nil)
            }
            let str = appUpdateModel.toJSONString(prettyPrint: true)
            do {
                try str?.write(toFile: filePathOfBundle!, atomically: true, encoding: .utf8)
            } catch {
            }
        }
    }
//    //获取token
//    func getToken() -> String {
//        let appModel = getAppModel()
//        return (appModel?.token)!
//    }
    //写入token
    func setToken(token:String){
        var appModel = getAppModel()
        appModel?.token="Bearer "+token
        writeAppModel(appModel: appModel!)
    }
}
