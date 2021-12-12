
import UIKit
import RxSwift

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .red
    }
    var photoItem:PhotoModel!{
        didSet{
            if photoItem.download_url == "noImage" {
                label.isHidden = true
                imageView.image = UIImage(named: Constant.noImage)
            }
            label.isHidden = false
            label.text = photoItem.author
            imageView.downloadImage(url: photoItem.download_url)
        }
    }
}
