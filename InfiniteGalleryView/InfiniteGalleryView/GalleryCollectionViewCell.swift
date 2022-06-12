//
//  GalleryCollectionViewCell.swift
//  InfiniteGalleryView
//
//  Created by 김희진 on 2022/06/12.
//

import Foundation
import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {

    static let identifier = "GalleryCollectionViewCell"
        
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
        
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(photoImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.frame = contentView.bounds
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    
    
}
