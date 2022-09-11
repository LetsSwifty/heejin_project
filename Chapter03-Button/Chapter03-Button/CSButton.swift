//
//  CSButton.swift
//  Chapter03-Button
//
//  Created by 김희진 on 2022/09/10.
//

import Foundation
import UIKit

public enum CSButtonType {
    case rect
    case circle
}

class CSButton: UIButton {
    
    var style: CSButtonType = .rect {
        // 프로퍼티 옵저버. 특정 프로퍼티의 값이 변할때마다 자동으로 호출되는 코드 블록. 프로퍼티의 값 변경을 감시하는 이벤트 리스너이다.
        // didSet 안에 있는 코드는 프로퍼티의 값이 변경된 직후에 실행된다.
        // willSet 은 값이 변경되기 직전에 수행된다.
        didSet {
            switch style {
            case .rect:
                self.layer.cornerRadius = 0
                self.setTitle("네모버튼2", for: .normal)
                self.setTitleColor(.black, for: .normal)
                self.backgroundColor = .cyan
            case .circle:
                self.layer.cornerRadius = 0
                self.setTitle("원버튼2", for: .normal)
                self.setTitleColor(.black, for: .normal)
                self.backgroundColor = .brown
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        // init(coder: ) 은 스토리보드 방식으로 객세를 생성할때 호출되는 초기화 메소드이다. 프로그래밍 코드에서도 마찬가지로 이 초기화 메소드를 사용한다.!!!!!
        super.init(coder: aDecoder)!
        
        self.backgroundColor = .green
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.setTitle("버튼", for: .normal)
    }
    
    override init(frame: CGRect) {
        // 스토리보드를 이용할때에는 이건 작성하지 않아도 된다. 하지만 프로그래밍 방식일때는 꼭 필요! 왜냐하면 위의 메소드에서 NsCoder은 스토리보드에서 자동으로 생성되기 때문에 이 값을 코드베이스로 채워 넣기 힘들다. 그래서 프로그래밍 방식을 할때는 CGRect를 인자로 받는 init 오버라이딩이필요하다!
        // frame을 넣는 이유는 부모 클래스를 초기화 할 때 사용하기 위해서이다. 즉, UIButton()을 초기화 하기 위해서는 CGRect 값이 필요한데, 초기화 메소드를 통해 이 값을 입력받으면 좋기 때문이다!!!!
        super.init(frame: frame) // 단순이 여기까지만 작성한다면 버튼의 속성이 전혀 설정되지 않았기 때문에 기본 버튼과 동일한 UIButton() 속성만 가진다. 커스텀 클래스가 적용되었음을 알아보기 쉽도록 이 초기화 구문 내에서도 설정이 필요! 그 내용은 요기 아래 부분에 작성한다.

        self.backgroundColor = .gray
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.setTitle("코드로 생성된 버튼", for: .normal)
    }

    init() {
        super.init(frame: CGRect.zero)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.setTitle("코드로 생성된 버튼2", for: .normal)
        self.setTitleColor(.black, for: .normal)
    }
    
    convenience init(type: CSButtonType) {
        self.init()
        switch type {
        case .rect:
            self.layer.cornerRadius = 0
            self.setTitle("네모버튼", for: .normal)
            self.setTitleColor(.black, for: .normal)
        case .circle:
            self.layer.cornerRadius = 30
            self.setTitle("원버튼", for: .normal)
            self.setTitleColor(.red, for: .normal)
        }
    
        self.addTarget(self, action: #selector(counting(_:)), for: .touchUpInside)
    }
    
    @objc func counting(_ sender: UIButton) {
        sender.tag = sender.tag + 1
        sender.setTitle("\(sender.tag)번째 클릭", for: .normal)
    }

}
