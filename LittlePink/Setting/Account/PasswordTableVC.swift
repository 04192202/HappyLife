//
//  PasswordTableVC.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/27.
//

import UIKit
import LeanCloud

class PasswordTableVC: UITableViewController {
    
    var user: LCUser!
    var setPasswordfinished:(() ->())?

    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var passwordTF:UITextField!
    @IBOutlet weak var confirmPasswordTF:UITextField!
    
    private var passwordSrt : String { passwordTF.unwrappedText }
    private var confirmPasswordSrt : String { confirmPasswordTF.unwrappedText }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        passwordTF.becomeFirstResponder()
    }
    
    @IBAction func done(_ sender: UIButton){
        
        if passwordSrt.isPassword && confirmPasswordSrt.isPassword{
            if passwordSrt == confirmPasswordSrt{
                //修改云端
                user.password = LCString(passwordSrt)
                try? user.set(kIsSetPasswordCol, value: true)
                user.save{ _ in }
                
                //修改UI
                dismiss(animated: true)
                setPasswordfinished?()
                
            }else{
                showTextHUD("两次密码不一致")
            }
        }else{
            showTextHUD("密码必须是6-16位的数字或字母")
        }
    }
    
    @IBAction func TFEditChanged(_ sender:Any){
        if passwordTF.isBlank || confirmPasswordTF.isBlank{
            doneBtn.isEnabled = false
        }else{
            doneBtn.isEnabled = true
        }
    }
}

extension PasswordTableVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case passwordTF:
            confirmPasswordTF.becomeFirstResponder()
        default:
            if doneBtn.isEnabled{
                done(doneBtn)
            }
        }
        return true
    }
}
