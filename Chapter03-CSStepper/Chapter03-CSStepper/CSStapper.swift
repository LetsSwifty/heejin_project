//
//  CSStapper.swift
//  Chapter03-CSStepper
//
//  Created by 김희진 on 2022/09/11.
//

import Foundation
import UIKit

@IBDesignable
class CSStepper: UIControl {
    public var leftButton = UIButton(type: .system)
    public var rightButton = UIButton(type: .system)
    public var centerLabel = UILabel()
    
    // 스테퍼의 현재 값을 저장할 변수
    @IBInspectable
    public var value: Int = 0 {
        didSet { //value의 값이 바뀌면 자동으로 호출된다.
            self.centerLabel.text = String(value)
            self.sendActions(for: .valueChanged) // 값이 변경되면 이벤트를 발생시키라는 의미이다.
        }
    }

    @IBInspectable
    public var leftTitle: String = "⇣" {
        didSet {
            self.leftButton.setTitle(leftTitle, for: .normal)
        }
    }
    

    @IBInspectable
    public var rightTitle: String = "⇡" {
        didSet {
            self.rightButton.setTitle(rightTitle, for: .normal)
        }
    }
    
    @IBInspectable
    public var bgColor: UIColor = .cyan {
        didSet {
            self.centerLabel.backgroundColor = bgColor
        }
    }
    
    @IBInspectable public var stepValue: Int = 1
    let borderW: CGFloat = 0.5
    let borderColor = UIColor.blue.cgColor
    
    @IBInspectable public var maximumV: Int = 100
    @IBInspectable public var minimumV: Int = 0
    
    public required init?(coder aDecoder: NSCoder) { // 스토리보드에서 초기화하는 메소드
        super.init(coder: aDecoder)
        self.setUp()
    }
    
    public override init(frame: CGRect) { // 프로그래밍 방식으로 호출할 초기화 메소드
        super.init(frame: frame)
        self.setUp()
    }
    
    private func setUp() {
        self.leftButton.tag = -1
        self.leftButton.setTitle(self.leftTitle, for: .normal)
        self.leftButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        self.leftButton.layer.borderColor = borderColor
        self.leftButton.layer.borderWidth = borderW
        self.leftButton.addTarget(self, action: #selector(valueChange), for: .touchUpInside)
        
        self.rightButton.tag = 1
        self.rightButton.setTitle(self.rightTitle, for: .normal)
        self.rightButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        self.rightButton.layer.borderColor = borderColor
        self.rightButton.layer.borderWidth = borderW
        self.rightButton.addTarget(self, action: #selector(valueChange), for: .touchUpInside)

        self.centerLabel.text = String(value)
        self.centerLabel.font = .systemFont(ofSize: 16)
        self.centerLabel.textAlignment = .center
        self.centerLabel.backgroundColor = bgColor
        self.centerLabel.layer.borderWidth = borderW
        self.centerLabel.layer.borderColor = borderColor
        
        self.addSubview(self.leftButton)
        self.addSubview(self.rightButton)
        self.addSubview(self.centerLabel)
    }
    
    @objc public func valueChange(_ sender: UIButton) {
        self.value += sender.tag
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        // self.frame은 스테퍼 뷰의 전체 크기를 의미한다.
        let btnW = self.frame.height
        let lblW = self.frame.width - (btnW * 2)
        
        self.leftButton.frame = CGRect(x: 0, y: 0, width: btnW, height: btnW)
        self.centerLabel.frame = CGRect(x: btnW, y: 0, width: lblW, height: btnW)
        self.rightButton.frame = CGRect(x: btnW + lblW, y: 0, width: btnW, height: btnW)
    }

    public func changeValue(_ sender: UIButton) {
        let sum = self.value + (sender.tag * self.stepValue)
        
        if sum > self.maximumV {
            return
        }
        if sum < self.minimumV {
            return
        }
        
        self.value += (sender.tag * self.stepValue)
    }
}
