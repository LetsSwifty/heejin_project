//
//  MemoReadVC.swift
//  MyMemory
//
//  Created by 김희진 on 2022/08/07.
//

import Foundation
import UIKit

class MemoReadVC: UIViewController {
    
    var param: MemoData?
    
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var contents: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.subject.text = param?.title
        self.contents.text = param?.contents
        self.imageView.image = param?.image
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd일 HH:mm분에 작성됨"
        let datestring = formatter.string(from: (param?.redate)!)
        
        self.navigationItem.title = datestring
    }
}
