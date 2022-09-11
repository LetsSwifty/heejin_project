//
//  ViewController.swift
//  Chapter03-Button
//
//  Created by 김희진 on 2022/09/10.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRect(x: 30, y: 50, width: 150, height: 30)
        let csButton = CSButton(frame: frame)
        self.view.addSubview(csButton)
        
        let csButton2 = CSButton()
        csButton2.backgroundColor = .yellow
        csButton2.frame = CGRect(x: 30, y: 100, width: 150, height: 30)
        self.view.addSubview(csButton2)
        
        let csButton3 = CSButton(type: .rect)
        csButton3.frame = CGRect(x: 30, y: 300, width: 150, height: 30)
        self.view.addSubview(csButton3)
        
        let csButton4 = CSButton(type: .circle)
        csButton4.frame = CGRect(x: 200, y: 300, width: 150, height: 30)
        self.view.addSubview(csButton4)
        
        let propertyButton = CSButton(type: .circle)
        propertyButton.frame = CGRect(x: 200, y: 400, width: 150, height: 30)
        self.view.addSubview(propertyButton)
        
        propertyButton.style = .rect // 타원으로 정의된 버튼을 다시 네모로 수정!
    }
}

class A {
    var a = 0
    
    init(v: Int) {
        
    }
    
    convenience init(m: Int) {
        self.init(v: m)
    }
}

class B: A{
    var b = 0
    
    convenience init(f: Int) {
        self.init(v: f)
    }
}

let a1 = A(v: 0)
let b1 = B(f: 0)
let b2 = B(v: 0)
let b3 = B(m: 0)
