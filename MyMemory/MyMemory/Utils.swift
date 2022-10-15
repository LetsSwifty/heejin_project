//
//  Utils.swift
//  MyMemory
//
//  Created by 김희진 on 2022/10/03.
//

import Foundation
import Security
import Alamofire

class TokenUtils {
    
    //키 체인에 값을 저장하는 메소드
    func save(_ service: String, account: String, value: String) {
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecValueData: value.data(using: .utf8, allowLossyConversion: false)!
        ]
        
        //현재 저장되어있는 값 삭제
        SecItemDelete(keyChainQuery)
        
        //새로운 키체인 아이템 등록
        let status: OSStatus = SecItemAdd(keyChainQuery, nil)
        assert(status == noErr, "토큰 값 저장에 실패했습니다")
        NSLog("status: \(status)")
    }
    
    func load(_ service: String, account: String) -> String? {
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        //키 체인에 저장된 값을 읽어온다
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(keyChainQuery, &dataTypeRef)
        
        //성공하면 읽어온 값을 Data로 변환해서 다시 string으로 변환
        if status == errSecSuccess {
            let retrievedData = dataTypeRef as! Data
            let value = String(data: retrievedData, encoding: String.Encoding.utf8)
            return value
        } else {
            print("return nil status \(status)")
            return nil
        }
    }
    
    func delete(_ servce: String, account: String) {
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: servce,
            kSecAttrAccount: account
        ]
        
        //현재 저장되어 있는 값 삭제
        let status = SecItemDelete(keyChainQuery)
        assert(status == noErr, "토큰 값 삭제에 실패했습니다")
        NSLog("status: \(status)")
    }
    
    // 키 체인에 저장된 액세스 토큰을 이용하여 헤더를 만들어주는 메소드. 매번 인증헤더를 만들지 않고 얠 호출하면 됨
    func getAuthorizationHeader() -> HTTPHeaders? {
        let serviceId = "kr.co.rubypaper.MyMemory"
        if let accessToken = self.load(serviceId, account: "accessToken") {
            return ["Authorization": "Bearer \(accessToken)"] as HTTPHeaders
        } else {
            return nil
        }
    }
    
}

extension UIViewController {
    var tutorialSB: UIStoryboard {
        return UIStoryboard(name: "Tutorial", bundle: Bundle.main)
    }
    
    func instanceTutorialVC(name: String) ->  UIViewController? {
        return self.tutorialSB.instantiateViewController(withIdentifier: name)
    }
    
    func alert(_ message: String, completion: (() -> Void)? = nil) {
        //메인 쓰레드에서 실행되도록 보장
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .cancel) { _ in
                completion?()
            }
            
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
}
