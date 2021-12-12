
import Foundation
class GalleryValidationUtil: NSObject {
    
    static func isValid(userName: String) -> Bool {
        if(userName.count != 11){
            return false
        }
        let range = NSRange(location: 0, length: userName.utf16.count)
        let regex = try! NSRegularExpression(pattern: "[0-9]{11}$")
        if(regex.firstMatch(in: userName, options: [], range: range) != nil){
            return true
        }else{
            return false
        }
    }
    
    static func isValid(password: String) -> Bool {
        return password.count >= 8
    }
}
