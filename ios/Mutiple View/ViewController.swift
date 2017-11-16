import UIKit
import SSZipArchive

//var name = ""
class ViewController: UIViewController {
    
    static var i = 0
    let bundleManager:BundleManager? = BundleManager.getBundleManager()
    
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
        print("========viewController")
        BundleManager.viewController = self
        //bundleManager?.goTo(view: self, name: "index")
        ViewController.i = ViewController.i+1
        print("iiiiiiiiiiiiiiii")
        print(ViewController.i)
        DispatchQueue.main.async {
            self.bundleManager?.loadMainBundle(view: self, name: "index")
        }
        //        if( ViewController.i == 1){
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("========ViewController viewDidLoad")
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool)
    {
        print("=========ViewController viewDidAppear")
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("=========ViewController viewWillDisappear")
        BundleManager.mainView = self.view
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("=========ViewController didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
    }
}

