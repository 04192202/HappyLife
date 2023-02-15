//
//  LoginVC.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/12.
//

import UIKit

 class LoginVC: UIViewController {
    
    
     lazy private  var loginBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("登录", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = mainColor
        btn.layer.cornerRadius = 22
        btn.addTarget(self, action: #selector(localLogin), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(loginBtn)
        setUI()
        
    }
    //约束
    private func setUI(){
        loginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        loginBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
    }
    
}
