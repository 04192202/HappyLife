//
//  PasswordLoginVC.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/14.
//

import UIKit

class PasswordLoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func backToCodeLoginVC(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    

}
