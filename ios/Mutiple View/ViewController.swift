import UIKit
import SSZipArchive

var name = ""
class ViewController: UIViewController {
    
    @IBOutlet weak var outlet: UITextField!
    
    @IBAction func action(_ sender: Any) {
        if(outlet.text != ""){
            name = outlet.text!
            performSegue(withIdentifier: "segue", sender: self)
        }
        
    }
    override func loadView() {
        super.loadView()
        
        //let mydir1:String = NSHomeDirectory()+"/Documents"
        //let filePath:String = mydir1 + "/appInfo.txt"
        //let filePathUrl:URL = URL(fileURLWithPath: filePath)
        //let jsonString  = "{\"id\":1,\"name\":\"test\",\"currentVersion\":\"1.0.0\",\"path\":\"assets\"}"
        //let bundleModel:BundleModel = BundleModel.deserialize(from:jsonString)!
//        print(bundleModel.id)
//        print(bundleModel.name)
//        print(bundleModel.currentVersion)
//        print(bundleModel.path)
        
        copyBundleJson()
        //copyTestJson()
        var obj1 = getBundleJson()
        //var name1=getProty(obj: obj1!,proty: name)
        //setProty(obj: obj1!, proty: name, val: "aaa")
        //print(obj1)
        obj1?.name="hahaha"
        setBundleJson(appModel: obj1!)
        copyAssetsBundle(name: "index")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
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
    func getBundleJson() -> AppModel?{
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
        return AppModel.deserialize(from: "")
    }
    
    func setBundleJson(appModel:AppModel){
        do {
            let mydir:String = NSHomeDirectory()+"/Documents"
            let filePathOfBundle:String? = mydir+"/bundleModel.json"

            let str = appModel.toJSONString(prettyPrint: true)
            do {
                try str?.write(toFile: filePathOfBundle!, atomically: true, encoding: .utf8)
            } catch {
            }
        } catch  let error as NSError {
            print("Something went wrong: \(error)")
        }
    }
    //根据bundleModel获取属性
//    func getProty(obj:BundleModel,proty:String) -> String?{
//        return obj.name
//    }
    //根据bundleModel和属性设置值
//    func setProty(proty:String,val:Any){
//        var bundleModel = getBundleJson()
//        bundleModel?.name=val
//    }
    
    func copyTestJson(){
        var bundleModel = BundleModel()
        bundleModel.id=1
        bundleModel.name = "test"
        bundleModel.currentVersion = "1.0.0"
        bundleModel.path = "assets"
        var bundleModel2 = BundleModel()
        bundleModel2.id=2
        bundleModel2.name = "test2"
        bundleModel2.currentVersion = "2.0.0"
        bundleModel2.path = "assets2"
        var appModel = AppModel()
        appModel.id=2
        appModel.name = "Hand"
        appModel.bundleModels[bundleModel.name!] = bundleModel
        appModel.bundleModels[bundleModel2.name!] = bundleModel2
        print(appModel)
        let fileManager = FileManager.default
        let mydir:String = NSHomeDirectory()+"/Documents"
        
        let filePathOfBundle:String? = mydir+"/bundleModel.json"
        let existOfBundlePlist = fileManager.fileExists(atPath: filePathOfBundle!)
        let jsCodeStrOfBundlePlist = Bundle.main.path(forResource: "bundleModel", ofType: "json")
        if !existOfBundlePlist{
            do {
                try fileManager.copyItem(atPath: jsCodeStrOfBundlePlist!,toPath: filePathOfBundle!)
                let ur = URL(fileURLWithPath: filePathOfBundle!)
                let str = try String(contentsOf: ur,encoding: .utf8)
                print(str)
            }catch let error as NSError {
                print("Something went wrong: \(error)")
            }
        }
        do {
            let ur = URL(fileURLWithPath: filePathOfBundle!)
            let str = try String(contentsOf: ur,encoding: .utf8)
            print(str)
//            var bundleModel:BundleModel = BundleModel.deserialize(from:str)!
//            print(bundleModel.id)
//            print(bundleModel.name)
//            print(bundleModel.currentVersion)
//            print(bundleModel.path)
//            bundleModel.id = 2
            let str2 = appModel.toJSONString(prettyPrint: true)
//            print(bundleModel2)
            do {
                try str2?.write(toFile: filePathOfBundle!, atomically: true, encoding: .utf8)
            } catch {
            }
        } catch  let error as NSError {
            print("Something went wrong: \(error)")
        }

        
    }


}

