//
//  ViewController.swift
//  Delegate_imagePicker
//
//  Created by 김희진 on 2022/04/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imgView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func pick(_ sender: Any) {

        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        
        self.present(picker, animated: true)
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //이미지를 선택했을 때 호출되는 메서드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: false) {

            // info에는 사용자가 선택한 이미지 정보가 담겨서 전달되기 때문에 이미지 정보 추출 가능
            let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            self.imgView.image = img
        }
    }

    //델리게이트 메소드를 구현하지 않았을 때는 이미지 피커를 취소하거나 이미지를 선택하면 자동으로 해당 컨트롤러에 창의 닫히지만, 델리게이트 메소드를 구현하게 되면 컨트롤러 창을 닫기 위한 dismiss 메소드를 직접 호출해 주어야 한다.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        picker.dismiss(animated: false) {
            let alert = UIAlertController(title: "", message: "이미지 선택이 취소되었습니다", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            self.present(alert, animated: false)
        }
    }
}
