import UIKit
import React

class SecondViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    var name:String?
    
//    override func viewWillAppear(_ animated: Bool) {
//        //label.text = name
//        print("-----second-----")
//        print(self.hashValue)
//        let bundleManager:BundleManager? = BundleManager.getBundleManager()
//        BundleManager.secondView = self
//        bundleManager?.loadBundle(view: self,name:"second")
//        
//    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        //label.text = name
        print("-----second-----")
        let bundleManager:BundleManager? = BundleManager.getBundleManager()
        BundleManager.secondView = self
        bundleManager?.loadBundle(view: self,name:"second")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
