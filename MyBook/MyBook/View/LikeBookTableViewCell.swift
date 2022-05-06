//
//  LikeBookTableViewCell.swift
//  MyBook
//
//  Created by 김희진 on 2022/05/07.
//

import Foundation
import UIKit
import SnapKit

class LikeBookTableViewCell: UITableViewCell {

    static let identifier = "LikeBookTableViewCell"
    
    lazy var bookImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var bookTitle: UILabel = {
        let label = UILabel()
        label.text = "책제목"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var bookDiscription: UILabel = {
        let label = UILabel()
        label.text = "책설명dhjfg sjdhgfhsadgf jshgfdjh a   gdsfjka ghsdfkga dkjhga sdkfjghaskdjhfgkjhg"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash.circle"), for: .normal)
        return button
    }()

        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [bookImage, bookTitle, bookDiscription, deleteButton].forEach{ contentView.addSubview($0) }
        
        bookTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(90)
            make.trailing.equalToSuperview().inset(40)
            make.top.equalToSuperview().offset(5)
        }
        
        bookDiscription.snp.makeConstraints { make in
            make.top.equalTo(bookTitle.snp.bottom).offset(10)
            make.leading.equalTo(bookTitle.snp.leading)
            make.trailing.equalTo(bookTitle.snp.trailing)
            make.bottom.equalToSuperview().inset(8)
        }
        
        bookImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(70)
            make.height.equalTo(80)
            make.centerY.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
            make.width.height.equalTo(30)
        }

    }
        
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
