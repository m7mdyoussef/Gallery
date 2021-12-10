//
//  ViewController.swift
//  Gallery
//
//  Created by TWI on 10/12/2021.
//

import UIKit

class GallerySplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            if GalleryUser.sharedUser.isLoggedIn {
                print("is logged in")
//                let VC = self.storyboard?.instantiateViewController(identifier: "c") as! HomeViewController
//                self.navigationController?.pushViewController(VC, animated: true)
            }else{
                print("is logged out")
                let VC = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
        
    }
    
    
}

