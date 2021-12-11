//
//  PhotoDetailsViewController.swift
//  Gallery
//
//  Created by TWI on 11/12/2021.
//

import UIKit
import SDWebImage

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var downLoadUrlLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var autherLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var photoModel:PhotoModel? = PhotoModel(id: "", author: "", width: 0, height: 0, download_url: "", url: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        idLabel.text! += photoModel?.id ?? ""
        autherLabel.text! += photoModel?.author ?? ""
        widthLabel.text! += "\(photoModel?.width ?? 0)" 
        heightLabel.text! += "\(photoModel?.height ?? 0)"
        urlLabel.text! += photoModel?.url ?? ""
        downLoadUrlLabel.text! += photoModel?.download_url ?? ""

        image.sd_setImage(with: URL(string: photoModel?.download_url ?? ""), placeholderImage: UIImage(named: "no-image")) {_,_,_,_ in
            self.view.backgroundColor = self.image.image?.averageColor
        }
    }
    
    @IBAction func uiClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
