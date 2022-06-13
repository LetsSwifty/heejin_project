//
//  InfiniteGalleryView++Bundle.swift
//  InfiniteGalleryView
//
//  Created by 김희진 on 2022/06/13.
//

import Foundation

//private var APIKey: String {
//  get {
//    // 1
//    guard let filePath = Bundle.main.path(forResource: "GalleryInfo", ofType: "plist") else {
//      fatalError("Couldn't find file 'Info.plist'.")
//    }
//    // 2
//    let plist = NSDictionary(contentsOfFile: filePath)
//    guard let value = plist?.object(forKey: "API_KEY") as? String else {
//      fatalError("Couldn't find key 'API_KEY' in 'Info.plist'.")
//    }
//    return value
//  }
//}


extension Bundle {
    var apiKey: String {
        guard let file = self.path(forResource: "GalleryInfo", ofType: "plist") else { return ""}
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["API_KEY"] as? String else { fatalError("Couldn't find key 'API_KEY' in 'Info.plist'.")
        }
        return key
    }
}
