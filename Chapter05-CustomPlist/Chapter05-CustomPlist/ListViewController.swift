//
//  ListViewController.swift
//  Chapter05-UserDefaults
//
//  Created by 김희진 on 2022/09/12.
//

import UIKit

class ListViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var married: UISwitch!
    
    var accountList = [String]()
    
    var defualtPlist: NSDictionary! // 메인번들에 정의된 plist 내용을 저장할 딕셔너리
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // 메인 번들에 UserInfo.plist 가 있으면 이를 읽어와 딕셔너리에 담는다. -> 템플릿 딕셔너리가 만들어진다.
         if let defaultPlistPath = Bundle.main.path(forResource: "UserInfo", ofType: "plist") {
            self.defualtPlist = NSDictionary(contentsOfFile: defaultPlistPath)
        }
        
        let plist = UserDefaults.standard
        self.name.text = plist.string(forKey: "name")
        self.married.isOn = plist.bool(forKey: "married")
        self.gender.selectedSegmentIndex = plist.integer(forKey: "gender")
        
        let picker = UIPickerView()
        picker.delegate = self // 피커뷰에 델리게이트 메소드를 호출할 대상이 자신임을 말해줌
        picker.dataSource = self
        self.account.inputView = picker // account라는 텍스트 필드의 inputView는 원래 키보드다. 이걸 빌려서 picker을 넣어준다.
        
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 35)
        toolbar.barTintColor = .lightGray
        self.account.inputAccessoryView = toolbar
        
        let done = UIBarButtonItem()
        done.title = "Done"
        done.target = self
        done.action = #selector(pickerDone)
        toolbar.setItems([done], animated: true)
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, done], animated: true)
        
        let new = UIBarButtonItem()
        new.title = "New"
        new.target = self
        new.action = #selector(newAccount)
        toolbar.setItems([new, flexSpace, done], animated: true)
        
        
        let accountList = plist.array(forKey: "accountlist") as? [String] ?? []
        self.accountList = accountList
        if let account = plist.string(forKey: "selectedAccount") {
            self.account.text = account
            
            let customPlist = "\(account).plist"
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            let clist = path.strings(byAppendingPaths: [customPlist]).first!
            let data = NSDictionary(contentsOfFile: clist) // NSMutableDictionary와 다르게 수정 불가능
            
            self.name.text = data?["name"] as? String
            self.gender.selectedSegmentIndex = data?["gender"] as? Int ?? 0
            self.married.isOn = data?["married"] as? Bool ?? false
        }
        
        if (self.account.text?.isEmpty)! {
            self.account.placeholder = "등록된 계정이 없습니다"
            self.gender.isEnabled = false
            self.married.isEnabled = false
        }
        
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newAccount))
    }
    
    @objc func newAccount(_ sender: Any) {
        self.view.endEditing(true) // 일단 열려있는 입력용 뷰부터 닫는다.
        
        let alert = UIAlertController(title: "새 계정을 입력하세요", message: nil, preferredStyle: .alert)
        
        alert.addTextField() {
            $0.placeholder = "ex> abv.gmail.com"
        }
        alert.addAction(UIAlertAction(title: "ok", style: .default) { _ in
            if let account = alert.textFields?[0].text {
                self.accountList.append(account)
                self.account.text = account
                
                // 입력된 값을 모두 초기화한다.
                self.name.text = ""
                self.gender.selectedSegmentIndex = 0
                self.married.isOn = false
                
                
                // 계정 목록을 통째로 저장한다.
                let plist = UserDefaults.standard
                plist.set(self.accountList, forKey: "accountlist")
                plist.set(account, forKey: "selectedAccount")
                plist.synchronize()
                
                self.gender.isEnabled = true
                self.married.isEnabled = true
            }
        })
        
        self.present(alert, animated: false)
    }
    
    @objc func pickerDone(_ sender: Any) {
        self.view.endEditing(true) // 이거 하면서 기존에 endEiditing 하던 부분은 지워준다.
        
        if let _account = self.account.text {
            let customPlist = "\(_account).plist"
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            let clist = path.strings(byAppendingPaths: [customPlist]).first!
            let data = NSDictionary(contentsOfFile: clist) // NSMutableDictionary와 다르게 수정 불가능
            
            self.name.text = data?["name"] as? String
            self.gender.selectedSegmentIndex = data?["gender"] as? Int ?? 0
            self.married.isOn = data?["married"] as? Bool ?? false
        }
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

// UserDefault
//        let plist = UserDefaults.standard
//        plist.set(value, forKey: "gender")
//        plist.synchronize() // 동기화 한번 시켜줌
        
        let customPlist = "\(self.account.text!).plist"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let plist = path.strings(byAppendingPaths: [customPlist]).first!

        // let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary()
        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defualtPlist) // 저장된 plist 커스텀 파일이 없을때 템플릿 딕셔너리를 넣는다. 이후 수정될 가능성이 있기 때문에 NSMutableDictinary로 만들어준다.
        
        data.setValue(value, forKey: "gender")
        data.write(toFile: plist, atomically: true)
    }
    
    @IBAction func changeMarried(_ sender: UISwitch) {
        let value = sender.isOn

// UserDefault
//        let plist = UserDefaults.standard
//        plist.set(value, forKey: "married")
//        plist.synchronize()

        let customPlist = "\(self.account.text!).plist"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let plist = path.strings(byAppendingPaths: [customPlist]).first!

        //        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary()
        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defualtPlist)
        
        data.setValue(value, forKey: "married")
        data.write(toFile: plist, atomically: true)
        
        // 실제로 저장이 잘 되었는지 경로를 찍어봄
        print("customPlist: ", plist)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 && !(self.account.text?.isEmpty)! {
            let alert = UIAlertController(title: nil, message: "이름을 입력하세요", preferredStyle: .alert)
            
            // 팝업에 텍스트 필드 추가
            alert.addTextField() {
                $0.text = self.name.text // 기본값을 넣어준다
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                // 이 순간 userDefault 에 저장한다.
                let value = alert.textFields?[0].text // 텍스트 필드가 여러개 일 수 있어서 배열의 첫번째걸로 처리한다

// UserDefaults 이용
//                let plist = UserDefaults.standard
//                plist.set(value, forKey: "name")
//                plist.synchronize()
                
                let customPlist = "\(self.account.text!).plist" //읽어올 파일명
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) // 앱 내에 생성된 문서 디렉토리 경로를 구한다
                let path = paths[0] as NSString
                let plist = path.strings(byAppendingPaths: [customPlist]).first! //파일명까지 추가된 경로
                
                // let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary() //읽은 파일을 딕셔너리 객체로 변환한다. 파일이 없다면 새로운 딕셔너리 객체를 생성한다.
                let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defualtPlist)
                
                data.setValue(value, forKey: "name") // 입력된 이름값을 딕셔너리 객체에 name 키로 저장한다.
                data.write(toFile: plist, atomically: true) // 딕셔너리객체를 커스텀 프로퍼티 파일로 저장한다.
                
                self.name.text = value
            })
            
            self.present(alert, animated: false)
        }
    }
    
    // 생성할 컴포넌트의 갯수를 정의
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    // 지정된 컴포넌트의 row 갯수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return accountList.count
    }
    
    // 각 행에 출력될 내용
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return accountList[row]
    }
    
    // 터치 액션 정의
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let account = self.accountList[row]
        self.account.text = account // 선택된 row를 텍스트 필드에 입력
 
        // 피커뷰에 툴바가 생겨서 필요 없어진다.
        //        self.view.endEditing(true) // endEditing 메소드는 대상뷰에게 텍스트 필드의 편집이 끝났음을  알려주어 입력 뷰를 닫는 역할
        
        let plist = UserDefaults.standard
        plist.set(account, forKey: "selectedAccount")
        plist.synchronize()
    }
}
