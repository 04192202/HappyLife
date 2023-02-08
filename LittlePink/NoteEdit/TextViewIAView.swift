//
//  TextViewIAView.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/2.
//

import UIKit

class TextViewIAView: UIView {

    @IBOutlet weak var doneBtn: UIButton!
   
    @IBOutlet weak var textCountStackView: UIStackView!
    
    @IBOutlet weak var textCountLabel: UILabel!
    
    @IBOutlet weak var macTextCountLabel: UILabel!
    

    var currentTextCount = 0{
        didSet{
            // 字符数小于8000隐藏完成按钮
            if currentTextCount <= kMaxNoteTextCount{
                doneBtn.isHidden = false
                textCountStackView.isHidden = true
            }else{
                // 如果字符大于等于8000 显示字符数
                doneBtn.isHidden = true
                textCountStackView.isHidden = false
                textCountLabel.text = "\(currentTextCount)"
            }
        }
    }

    
}
