//
//  ViewController.swift
//  Chapter03-NavigationBar
//
//  Created by 김희진 on 2022/09/10.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.initTitle()
//        self.initTitleNew()
//        self.initTitleImage()
//        self.initTitleInput()
        
//        self.initTabBarItem()
        
        self.initTitleInput2()
    }
    
    func initTitleInput2() {
        let tf = UITextField()
        tf.frame = CGRect(x: 0, y: 0, width: 300, height: 35)
        tf.backgroundColor = .white
        tf.font = UIFont.systemFont(ofSize: 13)
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.keyboardType = .URL
        tf.keyboardAppearance = .dark
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.green.cgColor
        self.navigationItem.titleView = tf
        
        
        let back = UIImage(named: "arrow-back")
        let leftItem = UIBarButtonItem(image: back, style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = leftItem
        
        
        let rv = UIView()
        rv.frame = CGRect(x: 0, y: 0, width: 70, height: 37)
        let rItem = UIBarButtonItem(customView: rv)
        self.navigationItem.rightBarButtonItem = rItem
        
        let cnt = UILabel()
        cnt.frame = CGRect(x: 10, y: 8, width: 20, height: 20)
        cnt.font = UIFont.boldSystemFont(ofSize: 10)
        cnt.textColor = .black
        cnt.text = "12"
        cnt.textAlignment = .center
        cnt.layer.cornerRadius = 3
        cnt.layer.borderWidth = 2
        cnt.layer.borderColor = UIColor.gray.cgColor
        rv.addSubview(cnt)
        
        let more = UIButton(type: .system)
        more.frame = CGRect(x: 50, y: 10, width: 16, height: 16)
        more.setImage(UIImage(named: "more"), for: .normal)
        rv.addSubview(more)
    }
    
    @objc func func1() {
        let alert = UIAlertController(title: "SDf", message: "sddf", preferredStyle: .alert)
        let ok = UIAlertAction(title: "sdf", style: .default) { action in
            print("무슨 액션을 할까")
        }
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    func initTabBarItem() {
        // 기본 아이콘을 쓸 경우
        // target은 버튼을 클릭했을 때 호출할 메소드가 있는 인스턴스를 지정한다.
        let item = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(func1))
        self.navigationItem.leftBarButtonItem = item

        // 기본 아이콘을 쓰지 않을 경우
        let item2 = UIBarButtonItem(image: UIImage(named: "이미지명"), style: .plain, target: self, action: #selector(func1))
        self.navigationItem.rightBarButtonItem = item

        
        // 위의 둘처럼 단순 버튼기능을 하는데에서 벗어나 새로운 뷰를 UIBarButtonItem으로 넣을 경우
        let v = UIView()
        let leftItem = UIBarButtonItem(customView: v)
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    func initTitleInput() {
        let tf = UITextField()
        tf.frame = CGRect(x: 0, y: 0, width: 300, height: 35)
        tf.backgroundColor = .white
        tf.font = UIFont.systemFont(ofSize: 13)
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.keyboardType = .URL
        tf.keyboardAppearance = .dark
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.green.cgColor
        
        self.navigationItem.titleView = tf
        
        
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: 150, height: 37)
        v.backgroundColor = .brown
        let leftItem = UIBarButtonItem(customView: v)
        self.navigationItem.leftBarButtonItem = leftItem
        
        let rv = UIView()
        rv.frame = CGRect(x: 0, y: 0, width: 100, height: 37)
        rv.backgroundColor = .red
        let rightItem = UIBarButtonItem(customView: rv)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    func initTitleImage() {
        let image = UIImage(named: "swift_logo")
        let imageV = UIImageView(image: image)
        self.navigationItem.titleView = imageV
    }
    
    func initTitleNew() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 36))

        let topTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 18))
        topTitle.numberOfLines = 1
        topTitle.textAlignment = .center
        topTitle.font = UIFont.systemFont(ofSize: 15)
        topTitle.textColor = .white
        topTitle.text = "58개의 숙소"

        let subTitle = UILabel(frame: CGRect(x: 0, y: 18, width: 200, height: 18))
        subTitle.numberOfLines = 1
        subTitle.textAlignment = .center
        subTitle.font = UIFont.systemFont(ofSize: 12)
        subTitle.textColor = .white
        subTitle.text = "1박(1월 10일 ~ 1월 11일)"
        
        containerView.addSubview(topTitle)
        containerView.addSubview(subTitle)

        // 뷰 컨트롤러에서는 네비게이션 아이템으로 접근을 바로 할 수 있다.
        self.navigationItem.titleView = containerView
        
        // 뷰 컨트롤러에서 네비게이션 바를 직접 접근하지 못하고, 상위의 네비게이션 컨트롤러를 통해 접근을 해야한다. 이 방식은 탭바쪽도 마찬가지!
        self.navigationController?.navigationBar.backgroundColor = .black
    }

    func initTitle() {
        let nTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        nTitle.numberOfLines = 2
        nTitle.textAlignment = .center
        nTitle.font = .systemFont(ofSize: 15)
        nTitle.text = "58개의 숙소 \n1박(1월 10일 ~ 1월 11일)"
        nTitle.textColor = .white
        
        // 뷰 컨트롤러에서는 네비게이션 아이템으로 접근을 바로 할 수 있다.
        self.navigationItem.titleView = nTitle
        
        // 뷰 컨트롤러에서 네비게이션 바를 직접 접근하지 못하고, 상위의 네비게이션 컨트롤러를 통해 접근을 해야한다. 이 방식은 탭바쪽도 마찬가지!
        self.navigationController?.navigationBar.backgroundColor = .black
    }
}
