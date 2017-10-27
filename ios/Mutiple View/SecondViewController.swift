import UIKit
import React

class SecondViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidAppear(_ animated: Bool)
    {
        //label.text = name
        
        //let jsCodeLocation = URL(string: "http://127.0.0.1:8081/index.ios.bundle?platform=ios")
        let jsCodeStr = Bundle.main.path(forResource: "index.ios", ofType: "jsbundle")
        let jsCodeUrl:URL? = URL(fileURLWithPath: jsCodeStr!)
        let mockData:NSDictionary = ["scores":
            [
                ["name":"1", "value":"1"],
                ["name":"2", "value":"2"]
            ]
        ]
        
        let rootView = RCTRootView(
            bundleURL: jsCodeUrl,
            moduleName: "Mutiple-View",
            initialProperties: mockData as [NSObject : AnyObject],
            launchOptions: nil
        )
        let vc = UIViewController()
        vc.view = rootView
        self.present(vc, animated: true, completion: nil)

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
