//
//  CustomViews.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/17.
//

import Foundation
// MARK: - 自定义的view
@IBDesignable //实时显示样式在custom
class BigButton : UIButton {
    //重新定义一个圆角
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        shareInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        shareInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        shareInit()
    }
    
    
    private func shareInit(){
        backgroundColor = .secondarySystemBackground
        tintColor = .placeholderText
        setTitleColor(.placeholderText, for: .normal)
        //左对齐
        contentHorizontalAlignment = .leading
        //边距
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
}
