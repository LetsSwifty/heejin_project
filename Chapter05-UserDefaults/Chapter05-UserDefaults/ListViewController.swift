//
//  ListViewController.swift
//  Chapter05-UserDefaults
//
//  Created by 김희진 on 2022/09/12.
//

import UIKit

class ListViewController: UITableViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var married: UISwitch!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let plist = UserDefaults.standard
        self.name.text = plist.string(forKey: "name")
        self.married.isOn = plist.bool(forKey: "married")
        self.gender.selectedSegmentIndex = plist.integer(forKey: "gender")
    }
    
    @IBAction func edit(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: "이름을 입력하세요", preferredStyle: .alert)
        
        // 팝업에 텍스트 필드 추가
        alert.addTextField() {
            $0.text = self.name.text // 기본값을 넣어준다
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            // 이 순간 userDefault 에 저장한다.
            let value = alert.textFields?[0].text // 텍스트 필드가 여러개 일 수 있어서 배열의 첫번째걸로 처리한다
            
            let plist = UserDefaults.standard
            plist.set(value, forKey: "name")
            plist.synchronize()
            
            self.name.text = value
        })        
        self.present(alert, animated: false)
    }
    
    @IBAction func changeGender(_ sender: UISegmentedControl) {
        let value = sender.selectedSegmentIndex
    
        let plist = UserDefaults.standard
        plist.set(value, forKey: "gender")
        plist.synchronize() // 동기화 한번 시켜줌
    }
    
    @IBAction func changeMarried(_ sender: UISwitch) {
        let value = sender.isOn
        
        let plist = UserDefaults.standard
        plist.set(value, forKey: "married")
        plist.synchronize()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let alert = UIAlertController(title: nil, message: "이름을 입력하세요", preferredStyle: .alert)
            
            // 팝업에 텍스트 필드 추가
            alert.addTextField() {
                $0.text = self.name.text // 기본값을 넣어준다
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                // 이 순간 userDefault 에 저장한다.
                let value = alert.textFields?[0].text // 텍스트 필드가 여러개 일 수 있어서 배열의 첫번째걸로 처리한다
                
                let plist = UserDefaults.standard
                plist.set(value, forKey: "name")
                plist.synchronize()
                
                self.name.text = value
            })
            
            self.present(alert, animated: false)
        }
    }
}

