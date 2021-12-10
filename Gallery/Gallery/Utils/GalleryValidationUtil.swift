
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
    
//    static func isValid(mobileNumber: String) -> Bool {
//        let phoneUtil = NBPhoneNumberUtil()
//        do {
//            var phoneNumber: NBPhoneNumber?
//            #if DEBUG
//            phoneNumber = try phoneUtil.parse(mobileNumber, defaultRegion: "EG")
//            #else
//            phoneNumber = try phoneUtil.parse(mobileNumber, defaultRegion: "US")
//            #endif
//            let isValid = phoneUtil.isValidNumber(phoneNumber)
//            return isValid
//        } catch let error as NSError {
//            TWILogger.shared().logInfo(-1, message:error.localizedDescription)
//        }
//        return false
//    }
}
