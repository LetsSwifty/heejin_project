//
//  ImageViewController.swift
//  Chapter03-Alert
//
//  Created by 김희진 on 2022/09/10.
//

import UIKit

class ImageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let icon = UIImage(named: "rating5")
        let iconV = UIImageView(image: icon)
        iconV.frame = CGRect(x: 0, y: 0, width: (icon?.size.width)!, height: (icon?.size.height)!)

        //루트뷰에 이미지 뷰를추가
        self.view.addSubview(iconV)
        // 외부에서 참조할뷰 컨트롤러 사이즈를 이미지 크기와 동일하게 설정
        self.preferredContentSize = CGSize(width: (icon?.size.width)!, height: (icon?.size.height)! + 10)
    }
}
