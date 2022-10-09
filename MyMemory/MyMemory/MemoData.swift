//
//  MemoData.swift
//  MyMemory
//
//  Created by 김희진 on 2022/08/07.
//

import Foundation
import UIKit
import CoreData

class MemoData {
    var memoIdx: Int?
    var title: String?
    var contents: String?
    var image: UIImage?
    var redate: Date?
    var objectID: NSManagedObjectID?
}
