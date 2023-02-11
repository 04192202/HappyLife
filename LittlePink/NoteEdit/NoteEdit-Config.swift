//
//  NoteEdit-Config.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/1.
//

import Foundation


extension NoteEditVC{
    func config(){
        hideKeyboardWhenTappedAround()
        
        // MARK: collectionview
        photoCollectionview.dragInteractionEnabled = true //开启拖放交互
        
        // MARK: titleCountLabel
        titleCountLabel.text = "\(kMaxNoteTitleCount)"
        
        // MARK: textView
        // 去除文本和placeholder的上下左右边距
        let lineFragmentPadding = textView.textContainer.lineFragmentPadding
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -lineFragmentPadding, bottom: 0, right: -lineFragmentPadding)
        // 行间距
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let typingAttributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.secondaryLabel
        ]
        textView.typingAttributes = typingAttributes
        // 光标颜色
        textView.tintColorDidChange()
        // 软键盘上面的view
        textView.inputAccessoryView = Bundle.loadView(fromNib: "TextViewIAView", with: TextViewIAView.self)
        textViewIAView.doneBtn.addTarget(self, action: #selector(resignTextView), for: .touchUpInside)
        textViewIAView.macTextCountLabel.text = "/\(kMaxNoteTextCount)"
        
        // MARK: 请求定位权限
        locationManager.requestWhenInUseAuthorization()
        AMapLocationManager.updatePrivacyShow(AMapPrivacyShowStatus.didShow, privacyInfo: AMapPrivacyInfoStatus.didContain)
        AMapLocationManager.updatePrivacyAgree(AMapPrivacyAgreeStatus.didAgree)
        // MARK: 文件相关
        //print(NSHomeDirectory()) //沙盒根目录,存文件时不建议直接访问根目录
        //两种寻找文件的方法
        //1.返回路径:NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        //2.返回URL:FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        //path为普通字符串,而url一般长这样
        //file:///xxx/xx.mov"(本地)/"https://xx/xx.mov"(远程)
        
        //关于沙盒中的Library/SplashBoard文件夹
        //系统会缓存LaunchScreen.storyboad中的图片,即使删除App也没用,故需手动删除,迭代时需加入代码(可能还需其余优化操作):
        //do {
        //    try FileManager.default.removeItem(atPath: "\(NSHomeDirectory())/Library/SplashBoard")
        //} catch {
        //    print(error)
        //}
        

    }
}
// MARK: - 监听
extension NoteEditVC{
    @objc private func resignTextView(){
        textView.resignFirstResponder()
    }
}
