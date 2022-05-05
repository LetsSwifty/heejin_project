//
//  BookTableViewCell.swift
//  MyBook
//
//  Created by 김희진 on 2022/05/06.
//

import Foundation
import UIKit
import SnapKit

class BookTableViewCell: UITableViewCell {

    static let identifier = "BookTableViewCell"
    
    lazy var bookImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "note")
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
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        return button
    }()

        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [bookImage, bookTitle, bookDiscription, likeButton].forEach{ contentView.addSubview($0) }

        bookImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(100)
            make.width.equalTo(70)
            make.centerY.equalToSuperview()
        }
        
        bookTitle.snp.makeConstraints { make in
            make.leading.equalTo(bookImage.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(40)
            make.top.equalTo(bookImage.snp.top).offset(5)
        }
        
        bookDiscription.snp.makeConstraints { make in
            make.top.equalTo(bookTitle.snp.bottom).offset(10)
            make.leading.equalTo(bookTitle.snp.leading)
            make.trailing.equalTo(bookTitle.snp.trailing)
            make.bottom.equalToSuperview().inset(8)
        }
        
        likeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
            make.width.height.equalTo(20)
        }

    }
        
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    
    
//    public func configure(with titles: [Title]) {
//        self.titles = titles
//        DispatchQueue.main.async { [weak self] in
//            self?.collectionView.reloadData()
//        }
//    }
}
