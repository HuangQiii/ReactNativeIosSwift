import UIKit
import React

class SecondViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidAppear(_ animated: Bool)
    {
        //label.text = name
        
        let bundleManager:BundleManager? = BundleManager.getBundleManager()
        bundleManager?.loadBundle(view: self,name:"index")
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
