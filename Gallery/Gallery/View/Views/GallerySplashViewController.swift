
import UIKit

class GallerySplashViewController: UIViewController {
    
    @IBOutlet private weak var splashImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        splashImage.image = UIImage(named: Constant.splash)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if GalleryUser.sharedUser.isLoggedIn {
                let VC = self.storyboard?.instantiateViewController(identifier: Constant.HomeViewController) as! HomeViewController
                self.navigationController?.pushViewController(VC, animated: true)
            }else{
                let VC = self.storyboard?.instantiateViewController(identifier: Constant.LoginViewController) as! LoginViewController
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
        
    }
    
    
}

