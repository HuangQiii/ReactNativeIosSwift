import UIKit
import React
class SecondViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    var name:String?
    
    override func viewDidAppear(_ animated: Bool)
    {
        //label.text = name
        print("-----second-----")
        let bundleManager:BundleManager? = BundleManager.getBundleManager()
        BundleManager.secondView = self
        print(name)
        bundleManager?.loadBundle(view: self,name:name!)
    }
}
