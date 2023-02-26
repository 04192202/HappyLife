//
//  MyDraftNoteWaterfallCell.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/24.
//

import UIKit

class MyDraftNoteWaterfallCell: UICollectionViewCell {

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        countLabel.text = "\(UserDefaults.standard.integer(forKey: kDraftNoteCount))"
    }

}
