//
//  ViewController.swift
//  Delegate-TextField
//
//  Created by 김희진 on 2022/04/23.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var tf: UITextField!
    @IBOutlet var tf2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tf.placeholder = "값을 입력하세요"
        tf.keyboardType = .alphabet
        tf.keyboardAppearance = .dark
        tf.returnKeyType = .join
        tf.enablesReturnKeyAutomatically = true
        
        tf.borderStyle = .line
        tf.backgroundColor = UIColor(white: 0.87, alpha: 1.0)
        tf.contentVerticalAlignment = .center //텍스트를 수직방향으로 중앙 정렬
        tf.contentHorizontalAlignment = .center //텍트스를 수평방향으로 중앙정렬
        tf.layer.borderColor = UIColor.darkGray.cgColor
        tf.layer.borderWidth = 2.0
        tf.textColor = .black
        
        tf.becomeFirstResponder()
        tf2.becomeFirstResponder()
        
        tf.delegate = self
    }

    @IBAction func action(_ sender: Any) {
        tf.resignFirstResponder()
    }
    
    @IBAction func input(_ sender: Any) {
        tf.becomeFirstResponder()
    }
    
    // 해당 텍스트 필드의 편집이 시작될때 자동으로 실행된다. 만약 리턴 false 가 되면 편집이 허용되지 않는다.
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("텍스트 필드의 편집이 시작됩니다.")
        return true
    }
    
    // 텍스트 필드의 편집이 시작된 후 호출
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("텍스트 필드의 편집이 시작되었습니다.")
    }
    
    // 텍스트 필드의 내용이 삭제될 때 호출
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("텍스트 필드의 내용이 삭제됩니다.")
        return true
    }
    
    //텍스트 필드의 내용이 변경될때 호출
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("텍스트필드의 내용이 \(string)으로 변경됩ㄴㄷ,ㅏ,.")
        
        // 숫자는 입력할 수 없도록 설정 가능!
        if Int(string) == nil {
            //10자까지만 입력할 수 있게 설정 가능!
            if (tf.text?.count)! + string.count > 10 {
                return false
            }else{
                return true
            }
        }else {
            return false
        }
    }
    
    //텍스트 필드의 리턴키가 눌러졌을 떄 호출
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tf.resignFirstResponder()
        print("텍스트 필드의 리턴키가 눌러졌습니다")
        return true
    }
    
    //텍스트 필드 편집이 종료될 때 호출
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("텍스트 필드의 편집이 종료됩니다.")
        return true
    }
    
    //텍스트 필드의 편집이 종료되었을 때 호출
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("텍스트 필드의 편집이 종료되었습니다")
    }
    
}

