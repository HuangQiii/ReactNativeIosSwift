import Foundation
import React
import SSZipArchive
import HandyJSON
import Alamofire


class BundleManager{
    
    static var bundleManager:BundleManager? = nil
    
    static func getBundleManager() -> BundleManager {
        if BundleManager.bundleManager == nil {
            bundleManager = BundleManager()
        }
        return bundleManager!
    }
    
    static var secondView:SecondViewController? = nil
    static var viewController:ViewController? = nil

    
    func goTo(view:UIViewController,name:String){
        if type(of:view) == ViewController.classForCoder() {
//            BundleManager.viewController?.dismiss(animated: true, completion: nil)
//        view.navigationController?.popViewController(animated: true)
            view.performSegue(withIdentifier: "ShowSecond", sender: name)
        }else{
            view.performSegue(withIdentifier: "show2", sender: name)
        }
    
    }
    //发送bundle检查是否更新，更新updatebundle
    func checkBundleConfigUpdate(){
        let bundleConfig=getAppModel()?.toJSON()
        
        let headers:HTTPHeaders = [
            "Content-Type":"application/json"
        ]
        
        Alamofire.request("http://10.211.98.188:8081/testLink", method: HTTPMethod.post, parameters: bundleConfig, encoding: JSONEncoding.default, headers:headers)
            .responseJSON{
                response in
                let json = response.result.value
                let data : Data! = try? JSONSerialization.data(withJSONObject: json!, options: [])
                let str = String(data:data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                self.writeAppUpdateModel(appUpdateModel: AppUpdateModel.deserialize(from: str)!)
            }
    }
    //下载bundle
    func downloadBundle(name:String,url:String){
        let destination: DownloadRequest.DownloadFileDestination = { _, response in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(name+"/"+name+".ios.zip")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        let parameters:Parameters=["Authorization":"bearer 2dc9b130-724c-403c-82c4-9299a99bf9f1"]
        Alamofire.download(url,parameters:parameters,to: destination)
            .downloadProgress { progress in
                print("当前进度: \(progress.fractionCompleted)")
            }
            .responseData { response in
                if let data = response.result.value {
                    print("下载完毕!")
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
            appUpdateModel.mainBundle = nil
            appModel.mainBundle?.id = bundleId
            appModel.mainBundle?.currentVersion = version
            appModel.mainBundle?.path = bundleFile
            appModelChange = true
            appUpdateModelChange = true
        } else {
            if(appUpdateModel.bundleUpdates[name] != nil){
                appUpdateModel.bundleUpdates[name] = nil
                appUpdateModelChange = true
            }
            if(appModel.bundleModels[name] != nil){
                appModel.bundleModels[name]?.id = bundleId
                appModel.bundleModels[name]?.currentVersion = version
                appModel.bundleModels[name]?.path = bundleFile
                appModelChange = true
            }else{
                var bundleModel:BundleModel = BundleModel()
                bundleModel.id = bundleId
                bundleModel.currentVersion = version
                bundleModel.name = name
                bundleModel.path = bundleFile
                appModel.bundleModels[name] = bundleModel
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
    func downloadIcon(name:String,url:String){
        let destination: DownloadRequest.DownloadFileDestination = { _, response in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("icon/icon.zip")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        let parameters:Parameters=["Authorization":"bearer 2dc9b130-724c-403c-82c4-9299a99bf9f1"]
        Alamofire.download(url,parameters:parameters,to: destination)
            .downloadProgress { progress in
                print("当前进度: \(progress.fractionCompleted)")
            }
            .responseData { response in
                if let data = response.result.value {
                    print("下载完毕!")
                    //解压到当前目录下
                }
        }
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
//        view.present(vc, animated: true, completion: nil)
        view.navigationController?.pushViewController(vc!, animated: true)
    }
    func loadMainBundle(view: ViewController,name:String){
        let mydir:String = NSHomeDirectory()+"/Documents"
        let filePath:String = mydir + "/index/"+name+".ios.jsbundle"
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
        let vc = BundleManager.viewController
        vc?.view = rootView
//        view.present(vc, animated: true, completion: nil)
        view.navigationController?.pushViewController(vc!, animated: true)
    }

    //初始化复制json和index，并根据json的bundle去复制压缩包
    func syncBundleConfig(){
        copyBundleJson()
        copyAssetsBundle(name: "index")
        let appModel:AppModel=getAppModel()!
        let appModelBundles=appModel.bundleModels
        for bundleModel:BundleModel? in appModelBundles.values {
            copyAssetsBundle(name: bundleModel!.name!)
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
        
        if !exist{//不存在复制并解压
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
    //复制配置表
    func copyBundleJson(){
        let fileManager = FileManager.default
        let mydir:String = NSHomeDirectory()+"/Documents"
        
        let filePathOfBundle:String = mydir+"/bundleModel.json"
        let existOfBundlePlist = fileManager.fileExists(atPath: filePathOfBundle)
        let jsCodeStrOfBundlePlist = Bundle.main.path(forResource: "bundleModel", ofType: "json")
        if !existOfBundlePlist{
            do {
                try fileManager.copyItem(atPath: jsCodeStrOfBundlePlist!,toPath: filePathOfBundle)
            }catch let error as NSError {
                print("copy bundle json went wrong: \(error)")
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
            //print(str)
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
            //print(str)
            let appUpdateModel:AppUpdateModel = AppUpdateModel.deserialize(from:str)!
            return appUpdateModel
        } catch let error as NSError {
            print("Something went wrong: \(error)")
        }
        return AppUpdateModel()
        //.deserialize(from: "")
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
    //获取token
    func getToken() -> String {
        let appModel = getAppModel()
        return (appModel?.token)!
    }
    //写入token
    func setToken(token:String){
        var appModel = getAppModel()
        appModel?.token=token
        writeAppModel(appModel: appModel!)
    }

}
