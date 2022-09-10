//
//  ViewController.swift
//  Chapter03-TabBar
//
//  Created by 김희진 on 2022/09/02.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = UILabel(frame: CGRect(x: 0, y: 100, width: 100, height: 30)) // x, width, height 는 임시 값이다
        title.text = "첫번째 탭"
        title.textColor = .red
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 14)
        
        title.sizeToFit()
        title.center.x = self.view.frame.width / 2
        self.view.addSubview(title)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let tabBar = self.tabBarController?.tabBar
        
// hidden 속성은 중간값이 없기 때문에 애니메이션이 동작하지 않는다. 아래처럼 alpha 값을 수정해야 한다.
//        tabBar?.isHidden = (tabBar?.isHidden == true) ? false : true
        
        UIView.animate(withDuration: 0.15) {
            tabBar?.alpha = (tabBar?.alpha == 0 ? 1 : 0)
        }
    }
}

