//
//  Book.swift
//  MyBook
//
//  Created by 김희진 on 2022/05/06.
//

import Foundation
import Realm
import RealmSwift

/* 사용하지 않음
struct Book {
    let title: String
    let description: String
    var isChecked: Bool
}
  
 //    private lazy var bookList: [Book] = [
 //        Book(title : "sd1", description : "책설명dhjfg sjdhgfhsadgf jshgfdjh a   gdsfjka ghsdfkga dkjhga sdkfjghaskdjhfgkjhg", isChecked : false ),
 //        Book(title : "sd2", description : "책설명dhjfg sjdhgfhsadgf jshgfdjh a   gdsfjka ghsdfkga dkjhga sdkfjghaskdjhfgkjhg", isChecked : true ),
 //        Book(title : "sd3", description : "책설명dhjfg sjdhgfhsadgf jshgfdjh a   gdsfjka ghsdfkga dkjhga sdkfjghaskdjhfgkjhg", isChecked : false ),
 //        Book(title : "sd4", description : "책설명dhjfg sjdhgfhsadgf jshgfdjh a   gdsfjka ghsdfkga dkjhga sdkfjghaskdjhfgkjhg", isChecked : true ),
 //        Book(title : "sd5", description : "책설명dhjfg sjdhgfhsadgf jshgfdjh a   gdsfjka ghsdfkga dkjhga sdkfjghaskdjhfgkjhg", isChecked : true )
 //    ]
 */

class Book2: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title2: String = ""
    @Persisted var description2: String = ""
    @Persisted var isChecked2: Bool = false
    @Persisted var bookImage2: String = ""
    
    convenience init(id: Int) {
        self.init()
        self.title2 = title2
    }
}
