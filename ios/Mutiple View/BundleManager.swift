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
    
    func loadMainBundle(){
        
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
    //secondviewcontroller打开bundle
    func loadBundle(view: SecondViewController,name:String){
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
        let vc = UIViewController()
        vc.view = rootView
        view.present(vc, animated: true, completion: nil)
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

}
