//
//  MovieCell.swift
//  MyMovieChart
//
//  Created by 김희진 on 2022/04/28.
//

import Foundation
import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    
    @IBOutlet var desc: UILabel!
    
    @IBOutlet var opendate: UILabel!
    
    @IBOutlet var rate: UILabel!
    
    @IBOutlet var thumbnail: UIImageView!
}
