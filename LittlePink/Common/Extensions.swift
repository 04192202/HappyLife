//
//  Extensions.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/1/31.
//

import UIKit

extension String{
    var isBlank: Bool{
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}


extension Optional where Wrapped == String {
    var unwrappedText: String { self ?? "" }// 如果是nil返回空串，不是nil返回本身
}

extension UITextField{
    var unwrappedText: String { text ?? "" } //如果是空的话返回字符串，非空返回本身
    var exacText : String{
        unwrappedText.isBlank ? "" :unwrappedText
    }
}

extension UITextView{
    var unwrappedText: String { text ?? "" } //如果是空的话返回字符串，非空返回本身
    var exacText : String{
        unwrappedText.isBlank ? "" :unwrappedText
    }
}

// MARK: - 相册名
extension Bundle{
    var appName: String{
        if let appName = localizedInfoDictionary?["CFBundleDisplayName"] as? String{
            return appName
        }else{
            return infoDictionary!["CFBundleDisplayName"] as! String
        }
    }
    // MARK: 静态属性和方法--1.直接用类名进行调用,2.省资源
    // MARK: static和class的区别
    //static能修饰class/struct/enum的存储属性、计算属性、方法;class能修饰类的计算属性和方法
    //static修饰的类方法不能继承；class修饰的类方法可以继承
    //在protocol中要使用static
    // 但是class比较少，基本都是实例化对象多 待后期做完回来看看
    
    //加载xib上的view
    //为了更通用，使用泛型。as?后需接类型，故形式参数需为T.Type，实质参数为XXView.self--固定用法
    //加载xib泛型  咐键 完成 xxx/800 config
    static func loadView<T>(fromNib name:String , with type: T.Type)->T {
        
        if let view = Bundle.main.loadNibNamed(name , owner: nil , options: nil)?.first as? T{
            
            return view
        }
        fatalError("加载\(type)类型view错误")
    }
    
}

// MARK: - 圆角
extension UIView{
    @IBInspectable// 属性栏
    var radius: CGFloat{
        get{
            layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
        }
    }
}
// MARK: - 提示框

extension UIViewController{
    
    // MARK: - 展示加载框或提示框
    
    // MARK: 加载框--手动隐藏
    func showLoadHUD(_ title: String? = nil){
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = title
    }
    func hideLoadHUD(){
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    // MARK: 提示框--自动隐藏
    func showTextHUD(_ title: String, _ subTitle: String? = nil){
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text //不指定的话显示菊花和下面配置的文本
        hud.label.text = title
        hud.detailsLabel.text = subTitle
        hud.hide(animated: true, afterDelay: 2)
    }
    
    // 点击空白处收起软键盘
    func hideKeyboardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false //取消当前点击对其他控键的影响
        view.addGestureRecognizer(tap)
        
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
}

