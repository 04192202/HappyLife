//
//  MeVC.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/9.
//

import UIKit
import LeanCloud


class MeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //1.sb上:上一个vc(MeVC)的navigationitem中修改为空格字符串串
        //2.代码:上一个vc(此页)navigationItem.backButtonTitle = ""
        navigationItem.backButtonDisplayMode = .minimal
    }

    
    @IBAction func logouttest(_ sender: Any) {

        LCUser.logOut()
        
        
        let loginVC = storyboard!.instantiateViewController(identifier: kLoginVCID)

        loginAndMeParentVC.removeChildren()

        loginAndMeParentVC.add(child: loginVC)
        
    }
    
    
    @IBAction func showDraftNotes(_ sender: Any) {
        
        let navi = storyboard!.instantiateViewController(identifier: kDraftNotesNaviID)
        navi.modalPresentationStyle = .fullScreen
        present(navi, animated: true)
    }
    
    
}


