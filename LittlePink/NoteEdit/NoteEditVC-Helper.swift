//
//  NoteEditVC-Helper.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/9.
//

import Foundation

extension NoteEditVC{
    func isValidateNote() -> Bool{
        
        guard !photos.isEmpty else {
            showTextHUD("至少需要传一张图片")
            return false
        }
        
        guard textViewIAView.currentTextCount <= kMaxNoteTextCount else {
            showTextHUD("正文最多输入\(kMaxNoteTextCount)字")
            return false
        }
        return true
    }
    // MARK: - 发布栏标题
    func handleTFEditChanged(){
        //当前有高亮文本时(拼音键盘)return
        guard titleTextField.markedTextRange == nil else { return }
        
        //用户输入完字符后进行判断,若大于最大字符数,则截取前面的文本(if里面第一行)
        if titleTextField.unwrappedText.count > kMaxNoteTitleCount{
            
            titleTextField.text = String(titleTextField.unwrappedText.prefix(kMaxNoteTitleCount))
            
            showTextHUD("标题最多输入\(kMaxNoteTitleCount)字")
            
            //用户粘贴文本后的光标位置,默认会跑到粘贴文本的前面,此处改成末尾
            DispatchQueue.main.async {
                let end = self.titleTextField.endOfDocument
                self.titleTextField.selectedTextRange = self.titleTextField.textRange(from: end, to: end)
            }
        }
        titleCountLabel.text = "\(kMaxNoteTitleCount - titleTextField.unwrappedText.count)"
    }
    
    func showAllowPushAlert(){
        UNUserNotificationCenter.current().getNotificationSettings{ settings in
            switch settings.authorizationStatus{
                //未授权，引导用户授权
            case .denied:
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: #""悦生活"想给您发送通知"#, message: "及时收到好玩又有趣的文章", preferredStyle: .alert)
                    let notAllowAction = UIAlertAction(title: "不允许", style: .cancel)
                    let allowAction = UIAlertAction(title: "允许", style: .default){ _ in
                        jumpToSetting()
                    }
                    alert.addAction(notAllowAction)
                    alert.addAction(allowAction)
                    self.view.window?.rootViewController?.present(alert, animated: true)
                }
            default:
                break
            }
        }
    }
}
