//
//  HomeCollectionViewCell.swift
//  PicViewer
//
//  Created by Ahmd Amr on 10/12/2021.
//  Copyright © 2021 ahmdamr. All rights reserved.
//

import UIKit
import RxSwift

class HomeCollectionViewCell: UICollectionViewCell, HomeCellViewModelDelegate {

    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    
    private var viewModel = CellViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .red
    }
    
    func cellConfig(photo: PhotoModel) {
        if photo.download_url == "" {
            label.isHidden = true
            imageView.image = UIImage(named: "no-image")
        }
        label.isHidden = false
        label.text = photo.author
        imageView.downloadImage(url: photo.download_url)
        //viewModel.downloadImage(url: photo.download_url)
    }

    func onFetchCompleted(with image: UIImage) {
        imageView.image = image
    }
    
    func onFetchFailed() {
        imageView.image = UIImage(named: "placeholder")
    }
}
