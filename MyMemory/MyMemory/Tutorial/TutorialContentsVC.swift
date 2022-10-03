//
//  TutorialContentsVC.swift
//  MyMemory
//
//  Created by 김희진 on 2022/10/03.
//

import Foundation
import UIKit

class TutorialContentsVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    
    var pageIndex: Int!
    var titleText: String!
    var imageFile: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bgImageView.contentMode = .scaleAspectFill
        
        self.titleLabel.text = self.titleText
        self.titleLabel.sizeToFit()
        
        self.bgImageView.image = UIImage(named: self.imageFile)
        
    }

}
