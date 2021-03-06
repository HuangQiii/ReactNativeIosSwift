import Foundation
import HandyJSON

struct AppUpdateModel: HandyJSON {
    var id:Int?
    var name:String?
    var version:String?
    var updateAble:Bool?
    var url:String?
    var targetVersion:String?
    var mainBundleUpdate:BundleUpdateModel?
    var bundlesUpdate = [String : BundleUpdateModel]()
}
