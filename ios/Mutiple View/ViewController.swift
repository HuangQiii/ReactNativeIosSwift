import UIKit
import SSZipArchive

//var name = ""
class ViewController: UIViewController {
    
    @IBOutlet weak var outlet: UITextField!
        
    func goToThree(_ sender: Any) {
        let bundleManager:BundleManager? = BundleManager.getBundleManager()
        bundleManager!.goTo(view: self,name: "Hello")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSecond"{
            let controller = segue.destination as! SecondViewController
            controller.name = sender as? String
        }
    }
    override func loadView() {
        super.loadView()
        print("viewController")
        BundleManager.viewController = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool)
    {
        let bundleManager:BundleManager? = BundleManager.getBundleManager()
        //bundleManager?.goTo(view: self, name: "index")
        bundleManager?.loadMainBundle(view: self, name: "index")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

