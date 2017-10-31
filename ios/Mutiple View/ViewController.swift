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
        
        let bundleManager:BundleManager? = BundleManager.getBundleManager()
        
        bundleManager!.copyBundleJson()
        bundleManager!.checkBundleConfigUpdate()

        bundleManager!.copyAssetsBundle(name: "index")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

