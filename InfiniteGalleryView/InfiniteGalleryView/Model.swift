//
//  Model.swift
//  InfiniteGalleryView
//
//  Created by 김희진 on 2022/06/12.
//

import Foundation

struct ImageModel: Codable {
    let urls: ImageURLS
}

struct ImageURLS: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
    let small_s3: String
}

