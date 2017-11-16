import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    var name:String?
    let bundleManager:BundleManager? = BundleManager.getBundleManager()
    
    override func loadView() {
        super.loadView()
        //label.text = name
        print("-----second-----")
        BundleManager.secondView = self
        print(name)
        bundleManager?.loadBundle(view: self,name:name!)
    }
}
