
import UIKit
import SDWebImage

class PhotoDetailsViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var downLoadUrlLabel: UILabel!
    @IBOutlet private weak var urlLabel: UILabel!
    @IBOutlet private weak var heightLabel: UILabel!
    @IBOutlet private weak var widthLabel: UILabel!
    @IBOutlet private weak var autherLabel: UILabel!
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var image: UIImageView!
    
    var photoModel:PhotoModel? = PhotoModel(id: "", author: "", width: 0, height: 0, download_url: "", url: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idLabel.text! += photoModel?.id ?? ""
        autherLabel.text! += photoModel?.author ?? ""
        widthLabel.text! += "\(photoModel?.width ?? 0)"
        heightLabel.text! += "\(photoModel?.height ?? 0)"
        urlLabel.text! += photoModel?.url ?? ""
        downLoadUrlLabel.text! += photoModel?.download_url ?? ""
        
        image.sd_setImage(with: URL(string: photoModel?.download_url ?? ""), placeholderImage: UIImage(named: Constant.noImage)) {_,_,_,_ in
            
            if let backClr = self.image.image?.averageColor {
                self.view.backgroundColor = backClr
                var clr = UIColor.black
                if !backClr.isLight {
                    clr = .white
                }
                self.idLabel.textColor = clr
                self.autherLabel.textColor = clr
                self.widthLabel.textColor = clr
                self.heightLabel.textColor = clr
                self.urlLabel.textColor = clr
                self.downLoadUrlLabel.textColor = clr
                self.titleLabel.textColor = clr
            }
            
        }
    }
    
    @IBAction func uiClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
