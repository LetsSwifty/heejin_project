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
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpCell()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpCell()
    }

    func setUpCell(){
        contentView.addSubview(photoImageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.frame = contentView.bounds
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func reloadImage(url: String) {
        DispatchQueue.global().async {
            let _url = URL(string: url)
            let data = try? Data(contentsOf: _url!)
                        
            DispatchQueue.main.async {
                self.photoImageView.image = UIImage(data: data!)
            }
        }
    }
}
