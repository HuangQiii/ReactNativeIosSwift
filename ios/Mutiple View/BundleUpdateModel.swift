import Foundation
import HandyJSON

struct BundleUpdateModel: HandyJSON {
    var bundleId:Int?
    var name:String?
    var targetVersion:String?
    var bundleVersionId:Int?
    var description:String?
    var isMain:Int?
}
