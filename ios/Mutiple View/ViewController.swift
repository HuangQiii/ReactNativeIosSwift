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
        
        let mydir1:String = NSHomeDirectory()+"/Documents"
        let filePath:String = mydir1 + "/testForZip.zip"
        
        let fileManager = FileManager.default
        let exist = fileManager.fileExists(atPath: filePath)
        if !exist{
            do {
                try fileManager.copyItem(atPath: "/Users/hailor/Work/mobile/QhTestMV/ios/Mutiple View/testForZip.zip",toPath: filePath)
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
        }
        SSZipArchive.unzipFile(atPath: filePath, toDestination: mydir1)
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

