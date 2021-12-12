//
//  HomeCollectionViewCell.swift
//  PicViewer
//
//  Created by Ahmd Amr on 10/12/2021.
//  Copyright © 2021 ahmdamr. All rights reserved.
//

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
                imageView.image = UIImage(named: "no-image")
            }
            label.isHidden = false
            label.text = photoItem.author
            imageView.downloadImage(url: photoItem.download_url)
        }
    }
}
