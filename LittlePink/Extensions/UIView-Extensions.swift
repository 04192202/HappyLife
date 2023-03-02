//
//  UIView-Extensions.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/3/2.
//

import Foundation

//sec 变 label color
extension UILabel{
    func setToLight(_ text:String){
        self.text = text
        textColor = .label
    }
}

extension UIButton{
    
    func setToEnabled(){
        isEnabled = true
        backgroundColor = mainColor
    }
    func setToDisabled(){
        isEnabled = false
        backgroundColor = mainLightColor
    }
    //变成胶囊按钮
    func makeCapsule(_ color: UIColor = .label){
        layer.cornerRadius = frame.height / 2
        layer.borderWidth = 1
        layer.borderColor = color.cgColor
    }
    
}

extension UIImage{
    //初始化构造器三原则:
    //1.指定构造器必须调用它直接父类的指定构造器方法--见FollowVC
    //2.便利构造器必须调用同一个类中定义的其它初始化方法
    //3.便利构造器在最后必须调用一个指定构造器
    convenience init?(_ data: Data?) {
        if let unwrappedData = data{
            self.init(data: unwrappedData)
        }else{
            return nil
        }
    }
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ jpegQuality: JPEGQuality) -> Data?{
        jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

extension UITextField{
    var unwrappedText: String { text ?? "" }
    var exactText: String { unwrappedText.isBlank ? "" : unwrappedText }
    var isBlank : Bool { unwrappedText.isBlank }
}
extension UITextView{
    var unwrappedText: String { text ?? "" }
    var exactText: String { unwrappedText.isBlank ? "" : unwrappedText }
    var isBlank: Bool { unwrappedText.isBlank }
}

extension UIView{
    @IBInspectable
    var radius: CGFloat{
        get{
            layer.cornerRadius
        }
        set{
            clipsToBounds = true
            layer.cornerRadius = newValue
        }
    }
}
//改变UIAlertAction里的字体颜色 keyvalue coding (kvc)改提示框的UI oc
extension UIAlertAction{
    func setTitleColor(_ color: UIColor){
        setValue(color, forKey: "titleTextColor")
    }
    var titleTextColor: UIColor? {
        get {
            value(forKey: "titleTextColor") as? UIColor
        }
        set {
            setValue(newValue, forKey: "titleTextColor")
        }
    }
}
