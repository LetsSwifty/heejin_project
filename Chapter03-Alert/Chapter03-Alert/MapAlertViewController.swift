//
//  MapAlertViewController.swift
//  Chapter03-Alert
//
//  Created by 김희진 on 2022/09/10.
//

import UIKit
import MapKit

class MapAlertViewController: UIViewController, ListProtocol {
    func test() {
        print("delegate test~")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let alertBtn = UIButton(type: .system)
        alertBtn.frame = CGRect(x: 0, y: 150, width: 100, height: 30)
        alertBtn.center.x = self.view.frame.width / 2
        alertBtn.setTitle("Map Alert", for: .normal)
        alertBtn.addTarget(self, action: #selector(mapAlert), for: .touchUpInside)
        self.view.addSubview(alertBtn)
        
        let imageBtn = UIButton(type: .system)
        imageBtn.frame = CGRect(x: 0, y: 200, width: 100, height: 30)
        imageBtn.center.x = self.view.frame.width / 2
        imageBtn.setTitle("Image Alert", for: .normal)
        imageBtn.addTarget(self, action: #selector(imageAlert), for: .touchUpInside)
        self.view.addSubview(imageBtn)
        
        let sliderBtn = UIButton(type: .system)
        sliderBtn.frame = CGRect(x: 0, y: 250, width: 100, height: 30)
        sliderBtn.center.x = self.view.frame.width / 2
        sliderBtn.setTitle("slider Alert", for: .normal)
        sliderBtn.addTarget(self, action: #selector(sliderAlert), for: .touchUpInside)
        self.view.addSubview(sliderBtn)
                
        let listBtn = UIButton(type: .system)
        listBtn.frame = CGRect(x: 0, y: 300, width: 100, height: 30)
        listBtn.center.x = self.view.frame.width / 2
        listBtn.setTitle("list Alert", for: .normal)
        listBtn.addTarget(self, action: #selector(listAlert), for: .touchUpInside)
        self.view.addSubview(listBtn)
    }
    
    @objc func listAlert(_ sender: UIButton) {
        let contentVC = ListViewController()
        contentVC.delegate = self
     
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.setValue(contentVC, forKey: "contentViewController")
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
 
    
    @objc func sliderAlert(_ sender: UIButton) {
        let contentVC = ControllerViewController()
     
        let alert = UIAlertController(title: nil, message: "평점을 입력하세요", preferredStyle: .alert)
        alert.setValue(contentVC, forKey: "contentViewController")
        
        let okAction = UIAlertAction(title: "OK", style: .default) {_ in
            print(contentVC.sliderValue)
        }
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }

    
    @objc func imageAlert(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: "평점은 다음과 같습니다", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        let contentVC = ImageViewController()
        alert.setValue(contentVC, forKey: "contentViewController")
        self.present(alert, animated: true)
    }
    
    @objc func mapAlert(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: "여기가 맞습니까?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        let contentVC = MapKitViewController()
        
        alert.setValue(contentVC, forKey: "contentViewController")        
        self.present(alert, animated: true)
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        print("\(indexPath.row) 선택되었음")
    }

}
