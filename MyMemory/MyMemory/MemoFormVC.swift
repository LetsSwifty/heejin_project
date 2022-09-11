//
//  MemoFormVC.swift
//  MyMemory
//
//  Created by 김희진 on 2022/08/07.
//

import Foundation
import UIKit

class MemoFormVC: UIViewController {

    var subject: String!
    
    @IBOutlet weak var contents: UITextView!
    @IBOutlet weak var preview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contents.delegate = self
        
        let bgImage = UIImage(named: "memo-background.png")!
        self.view.backgroundColor = UIColor(patternImage: bgImage)
        
        // 텍스트 뷰 투명하게 만듬
        self.contents.layer.borderWidth = 0
        self.contents.layer.borderColor = UIColor.clear.cgColor
        self.contents.backgroundColor = UIColor.clear
        
        // 텍스트 뷰 줄 간격 설정
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 9
        self.contents.attributedText = NSAttributedString(string: "", attributes: [.paragraphStyle: style])
        self.contents.text = ""
    }
    
    @IBAction func save(_ sender: Any) {
        
        let alertV = UIViewController()
        let iconImage = UIImage(named: "warning-icon-60")
        alertV.view = UIImageView(image: iconImage)
        alertV.preferredContentSize = iconImage?.size ?? .zero
        
        // 작성된 내용이 없으면
        guard self.contents.text?.isEmpty == false else {
            let alert = UIAlertController(title: nil, message: "내용을 입력해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.setValue(alertV, forKey: "contentViewController")
            self.present(alert, animated: true)
            return
        }
        
        // 작성된 내용이 있으면
        let data = MemoData()
        data.title = self.subject
        data.contents = self.contents.text
        data.image = self.preview.image
        data.redate = Date()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memoList.append(data)
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pick(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true // 이미지피커 컨트롤러의 이미지 편집을 허용한다.
        
        self.present(picker, animated: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let bar = self.navigationController?.navigationBar
        
        let ts = TimeInterval(0.3)
        UIView.animate(withDuration: ts) {
            bar?.alpha = (bar?.alpha == 0 ? 1 : 0)
        }
    }
    
}

///  이미지 피커 컨트롤러 델리게이트 메소드를 구현하는 데에 필요한 프로토콜

extension MemoFormVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// 이미지 피커 컨트롤러 델리게이트 메소드
    
    // MARK: 이미지가 선택되었을때 호출되는 델리게이트 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.preview.image = info[.editedImage] as? UIImage
        
        picker.dismiss(animated: false)
    }
}


/// 우리는 텍스트 뷰에 입력된 내용을 바탕으로 제목을 추출하여 네비게이션 바에 표시할 것이므로 내용을 입력하는 동안 내용이 즉각적으로 네비게이션 바에 반영하도록 위해 델리게이트를 사용한다.

extension MemoFormVC: UITextViewDelegate {

    // MARK: 텍스트뷰의 내용이 변경될 때 호출되는 델리게이트 메소드
    func textViewDidChange(_ textView: UITextView) {
        
        let contents = textView.text as NSString // string 보다 NSString 이 관련 메소드가 다양해서 사용
        let length = ( (contents.length > 15) ? 15 : contents.length )
        self.subject = contents.substring(with: NSRange(location: 0, length: length))
        
        self.navigationItem.title = self.subject
    }
}
