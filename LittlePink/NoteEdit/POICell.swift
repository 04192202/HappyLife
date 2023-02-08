//
//  POICell.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/6.
//

import UIKit

class POICell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    var poi = ["", ""]{
        didSet{
            nameLabel.text = poi[0]
            addressLabel.text = poi[1]
        }
    }
}
