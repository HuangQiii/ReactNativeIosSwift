import Foundation
import HandyJSON

struct AppModel: HandyJSON {
    var id:Int?
    var name:String?
    var currentVersion:String?
    var token:String?
    var url:String?
    var mainBundle:BundleModel?
    var bundleModels = [String : BundleModel]()
}
