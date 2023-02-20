//
//  CodeLoginVC.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/14.
//

import UIKit
import LeanCloud


private var totalTime = 60

class CodeLoginVC: UIViewController {

    
    private var timeRemain = totalTime
    
    @IBOutlet weak var authCodeTF: UITextField!
    
    @IBOutlet weak var phoneNumTF: UITextField!
    
    @IBOutlet weak var getAuthCodeBtn: UIButton!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    lazy private var timer = Timer()
    
    private var phoneNumStr : String { phoneNumTF.unwrappedText }
    private var authCodeStr : String { authCodeTF.unwrappedText }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //点击空白处收起软键盘
        hideKeyboardWhenTappedAround()
        
        loginBtn.setToDisabled()
       

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        phoneNumTF.becomeFirstResponder()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        
        dismiss(animated: true)
    }
    //sender 就是控件本身
    @IBAction func TFEditingChanged(_ sender: UITextField) {
        if sender == phoneNumTF{
            //判断用户输入的手机号是否合法，来决定 获取验证码的按钮展示
            //若按钮进入倒计时状态（disable）不隐藏
            getAuthCodeBtn.isHidden = !phoneNumStr.isPhoneNum && getAuthCodeBtn.isEnabled
        }
        
        if phoneNumStr.isPhoneNum && authCodeStr.isAuthCode{
            loginBtn.setToEnabled()
        }else{
            loginBtn.setToDisabled()
        }
       
    }
    
    
    
    
    //用timer做倒计时
    @IBAction func getAuthCode(_ sender: Any) {
        
        getAuthCodeBtn.isEnabled = false
        setAuthCodeBtnDisabledText()
        authCodeTF.becomeFirstResponder()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(changeAuthCodeBtnText), userInfo: nil, repeats: true)
       
            let variables: LCDictionary = ["name": LCString("悦生活"),  "ttl": LCNumber(5) ]

            LCSMSClient.requestShortMessage(
                mobilePhoneNumber: phoneNumStr,
                templateName: "",
                signatureName: "悦生活",
                variables: variables)
        { result in
//            switch result {
//            case .success:
//                break
//            case .failure(error: let error):
//                print(error)
//            }
            if case let .failure(error: error) = result{
                print(error.reason)
            }
        }
    }
    //   测试： 15525826658 961031
    @IBAction func login(_ sender: UIButton) {
        
        view.endEditing(true)
        
        showLoadHUD()
        LCUser.signUpOrLogIn(mobilePhoneNumber: phoneNumStr, verificationCode: authCodeStr){ result in
           
            switch result {
           case let.success(object: user):
                // 放入随机昵称
                let randomNickName = "小悦\(String.randomString(6))"
                self.configAfterLogin(user, randomNickName)
                
            case let.failure(error: error):
                self.hideLoadHUD()
                DispatchQueue.main.async {
                    self.showTextHUD("登录失败",true,error.reason)
                }
           }
        }
    }
    
}
// MARK: - UITextFieldDelegate
//和做编辑页面正文输入差不多 截取
extension CodeLoginVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      //如果是手机号就等于11 如果不是就等于6 因为解包的验证码只支持是6位
      //三元运算简洁一些感觉 如果用if写的话写6行
        let limit = textField == phoneNumTF ? 11:6
        //isExceed超出字符限制
        let isExceed = range.location >= limit || (textField.unwrappedText.count + string.count) > limit
        if isExceed{
            showTextHUD("最多只能输入\(limit)位")
        }
        return !isExceed
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == phoneNumTF{
            authCodeTF.becomeFirstResponder()
        }else{
            if loginBtn.isEnabled{
                login(loginBtn)
            }
        }
        
        return true
    }
}
// MARK: - 监听函数
extension CodeLoginVC{
    @objc private func changeAuthCodeBtnText(){
        timeRemain -= 1
        setAuthCodeBtnDisabledText()
        
        if timeRemain <= 0 {
            timer.invalidate()
            timeRemain = totalTime
            getAuthCodeBtn.isEnabled = true
            getAuthCodeBtn.setTitle("发送验证码", for: .normal)
            //防止在倒计时的时候用户修改成了非法手机号，在倒计时结束后仍旧显示为正常按钮
            getAuthCodeBtn.isHidden = !phoneNumStr.isPhoneNum
        }
    }
}
// MARK: - 一般函数
extension CodeLoginVC{
    private func setAuthCodeBtnDisabledText(){
        getAuthCodeBtn.setTitle("重新发送(\(timeRemain)s)", for: .disabled)
    }
}
