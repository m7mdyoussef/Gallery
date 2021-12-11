//
//  PhotoModel.swift
//  Gallery
//
//  Created by TWI on 11/12/2021.
//

import Foundation
import Foundation

struct PhotoModel: Decodable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let download_url: String
    let url: String
}
