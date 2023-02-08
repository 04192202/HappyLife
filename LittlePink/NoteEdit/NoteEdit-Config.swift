//
//  NoteEdit-Config.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/1.
//

import Foundation


extension NoteEditVC {
    func config(){
        //开启拖拽功能
        photoCollectionview.dragInteractionEnabled = true
        // 点击空白处收起软键盘
        hideKeyboardWhenTappedAround()
        titleCountLabel.text = "\(kMaxNoteTitleCount)"
        // 发布笔记正文文本距离 缩距 0 去除文本框边距
        let lineFragmentPadding = textView.textContainer.lineFragmentPadding
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -lineFragmentPadding, bottom: 0, right: -lineFragmentPadding)
        //textView.textContainer.lineFragmentPadding = 0
        
        
        // 添加正文行高
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        
        let typingAttributes :[NSAttributedString.Key : Any] = [
            .paragraphStyle: paragraphStyle,.font: UIFont.systemFont(ofSize: 14),.foregroundColor: UIColor.secondaryLabel]
        
        textView.typingAttributes = [NSAttributedString.Key.paragraphStyle:paragraphStyle]
        // 光标颜色
        textView.tintColorDidChange()
        //附键
        textView.inputAccessoryView = Bundle.loadView(fromNib: "TextViewIAView", with: TextViewIAView.self)
            
        textViewIAView.doneBtn.addTarget(self, action: #selector(resignTextView), for: .touchUpInside)
           
        textViewIAView.macTextCountLabel.text = "/\(kMaxNoteTextCount)"
       // MARK: - 请求定位权限
        locationManager.requestWhenInUseAuthorization()
        AMapLocationManager.updatePrivacyShow(AMapPrivacyShowStatus.didShow, privacyInfo: AMapPrivacyInfoStatus.didContain)
        
        AMapLocationManager.updatePrivacyAgree(AMapPrivacyAgreeStatus.didAgree)
        
        
//        AMapSearchAPI.updatePrivacyShow(AMapPrivacyShowStatus.didShow, privacyInfo: AMapPrivacyInfoStatus.didContain)
//
//        AMapSearchAPI.updatePrivacyAgree(AMapPrivacyAgreeStatus.didAgree)
        print(NSHomeDirectory())
// MARK: - 寻找沙盒，一般只用两种方式
        //路径
        //NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        //url 一般多为视频图片
        //FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
// MARK: - 如果要删除沙盒的话
        //do{
        //try FileManager.default.removeItem(atPath: "\(NSHomeDirectory())/Library/SplashBoard")
        // }catch{
        // print(error)
        //}
        }
    }


// MARK: - 监听
extension NoteEditVC{
    @objc private func resignTextView(){
        textView.resignFirstResponder()
    }
}

