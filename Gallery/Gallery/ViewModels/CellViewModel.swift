//
//  CellViewModel.swift
//  PicViewer
//
//  Created by Ahmd Amr on 10/12/2021.
//  Copyright © 2021 ahmdamr. All rights reserved.
//

import UIKit

protocol HomeCellViewModelDelegate: class {
    func onFetchCompleted(with image: UIImage)
    func onFetchFailed()
}

final class CellViewModel {
    private weak var delegate: HomeCellViewModelDelegate?

    private let networkManager = NetworkManager()
        
    func downloadImage(url: String) {
        networkManager.downloadImage(url: url) { (result) in
            switch result {
            case .failure(_):
                DispatchQueue.main.async {
                    self.delegate?.onFetchFailed()
                }
            case .success(let data):
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self.delegate?.onFetchCompleted(with: image)
                    }
                }
            }
        }
    }
}
