//
//  PasswordLoginVC.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/14.
//

import UIKit
import LeanCloud

class PasswordLoginVC: UIViewController {
    
    @IBOutlet weak var phoneNumTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    private var phoneNumSrt: String { phoneNumTF.unwrappedText }
    private var passwordStr: String { passwordTF.unwrappedText }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        hideKeyboardWhenTappedAround()
        loginBtn.setToDisabled()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        phoneNumTF.becomeFirstResponder()
    }

    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true) }
    
    @IBAction func backToCodeLoginVC(_ sender: Any) { navigationController?.popViewController(animated: true) }
    
    @IBAction func TFEditChanged(_ sender:Any){
        //实时判断
        if phoneNumSrt.isPhoneNum && passwordStr.isPassword{
            loginBtn.setToEnabled()
        }else{
            loginBtn.setToDisabled()
        }
    }
    
    @IBAction func login(_ sender:UIButton){
        //收起软件盘
        view.endEditing(true)
        
        showLoginHUD()
        LCUser.logIn(mobilePhoneNumber: phoneNumSrt, password: passwordStr){ result in
            
            
            switch result {
            case .success(object: let user):
                //登录成功后跳转到个人页面
                self.dismissAndShowMeVC(user)
                
            case .failure(error: let error):
                self.hideLoadHUD()
                DispatchQueue.main.async{
                    self.showTextHUD("登录失败", true , error.reason)
                }
            }
        }
    }

}

extension PasswordLoginVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let limit = textField == phoneNumTF ? 11 : 16
        //isExceed超出字符限制
        let isExceed = range.location >= limit || (textField.unwrappedText.count + string.count) > limit
        if isExceed{
            showTextHUD("最多只能输入\(limit)位")
        }
        return !isExceed
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case phoneNumTF:
            passwordTF.becomeFirstResponder()
            
        default:
            if loginBtn.isEnabled{ login(loginBtn) }
        }
        return true
    }
}
