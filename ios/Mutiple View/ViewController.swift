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
        print("loadview")
        let fileManager = FileManager.default
        let mydir:String = NSHomeDirectory()+"/Documents"
        
        let mydir1:String = mydir+"/index"
        try! fileManager.createDirectory(atPath: mydir1, withIntermediateDirectories: true, attributes: nil)
        
        let filePath:String = mydir1 + "/index.ios.zip"
        let filePathOfBundle:String = mydir+"/bundle.plist"
        
        let exist = fileManager.fileExists(atPath: filePath)
        let existOfBundlePlist = fileManager.fileExists(atPath: filePathOfBundle)
        
        let jsCodeStr = Bundle.main.path(forResource: "index.ios", ofType: "zip")
        //let jsCodeUrl:URL? = URL(fileURLWithPath: jsCodeStr!)
        let jsCodeStrOfBundlePlist = Bundle.main.path(forResource: "bundle", ofType: "plist")
        
        if !existOfBundlePlist{
            do {
                try fileManager.copyItem(atPath: jsCodeStrOfBundlePlist!,toPath: filePathOfBundle)
            }catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
        }
        
        if !exist{
            do {
                //try fileManager.copyItem(atPath: "/Users/hailor/Work/mobile/QhTestMV/ios/Mutiple View/testForZip.zip",toPath: filePath)
                try fileManager.copyItem(atPath: jsCodeStr!,toPath: filePath)
                SSZipArchive.unzipFile(atPath: filePath, toDestination: mydir1)
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
        }
        //SSZipArchive.unzipFile(atPath: filePath, toDestination: mydir1)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload")

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("did")

        // Dispose of any resources that can be recreated.
    }


}

