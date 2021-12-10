//
//  GalleryUser.swift
//  Gallery
//
//  Created by TWI on 10/12/2021.
//

import UIKit

class GalleryUser{
    
    var userName: String{
        get{
            if let userName: String = userDefaults.value(forKey: GalleryCachingConstants.userName) as? String {
                return userName
            }
            return ""
        }
        set{
            userDefaults.set(newValue, forKey: GalleryCachingConstants.userName)
            userDefaults.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: GalleryCachingConstants.userNameChanged), object: nil)
        }
    }
    
    var password: String{
        get{
            if let password: String = userDefaults.value(forKey: GalleryCachingConstants.password) as? String {
                return password
            }
            return ""
        }
        set{
            userDefaults.set(newValue, forKey: GalleryCachingConstants.password)
            userDefaults.synchronize()
        }
    }
    
    var isLoggedIn:Bool {
        get{
            if let isLoggedIn: Bool = userDefaults.value(forKey: GalleryCachingConstants.isLoggedIn) as? Bool {
                return isLoggedIn
            }
            return false
        }
        set{
            userDefaults.set(newValue, forKey: GalleryCachingConstants.isLoggedIn)
            userDefaults.synchronize()
        }
    }
    

    
    public static let sharedUser = GalleryUser()
    private var userDefaults:UserDefaults
    
    private init(){
        userDefaults = UserDefaults.standard
    }
}
