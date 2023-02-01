//
//  PhotoFooter.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/1/31.
//

import UIKit

class PhotoFooter: UICollectionReusableView {
    
    
    @IBOutlet weak var addPhotoBtn: UIButton!
    //didaload
    override func awakeFromNib() {
        super.awakeFromNib()
        addPhotoBtn.layer.borderWidth = 1
        addPhotoBtn.layer.borderColor = UIColor.tertiaryLabel.cgColor
    }
    
}
