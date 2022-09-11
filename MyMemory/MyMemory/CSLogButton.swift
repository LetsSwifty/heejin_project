//
//  CSLogButton.swift
//  MyMemory
//
//  Created by 김희진 on 2022/09/11.
//

import Foundation
import UIKit

public enum CSLogType: Int {
    case basic //기본 로그 출력 타입
    case title //버튼 타이틀 출력 타입
    case tag   //태그 출력 타입
}

public class CSLogButton: UIButton {
    
    public var logType: CSLogType = .basic
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setBackgroundImage(UIImage(named: "button-bg"), for: .normal) //이거 왜 안먹는지 모르겠네
        self.tintColor = .white
        self.setTitle("커스텀 버튼", for: .normal)
        self.addTarget(self, action: #selector(logging), for: .touchUpInside)
    }
    
    @objc func logging(_ sender: UIButton) {
        switch self.logType {
        case .basic:
            NSLog("버튼이 클릭되었습니다")
        case .title:
            let title = sender.titleLabel?.text ?? "타이틀 없는"
            NSLog("\(title) 버튼이 클릭되었습니다")
        case .tag:
            NSLog("\(sender.tag) 버튼이 클릭되었습니다")
        }
    }
    
}
