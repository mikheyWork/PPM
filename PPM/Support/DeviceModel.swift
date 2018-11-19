import Foundation
import UIKit

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        if identifier.contains("iPad") {
            return "iPad"
        } else if identifier.contains("iPhone") {
            return "iPhone"
        } else if  identifier.contains("iPod") {
            return "iPhone"
        } else if identifier.contains("i386") {
            return "iPhone"
        } else if identifier.contains("x86_64") {
            return "iPhone"
//            iPhone
//            iPad
        } else {
            return "iPhone"
        }
    }
    
}
