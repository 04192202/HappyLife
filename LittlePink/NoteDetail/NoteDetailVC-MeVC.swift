//
//  NoteDetailVC-MeVC.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/23.
//

import Foundation
import LeanCloud

extension NoteDetailVC{
    func noteToMeVC(_ user: LCUser?){
        guard let user = user else { return }
        
        if isFromMeVC, let fromMeVCUser = fromMeVCUser, fromMeVCUser == user{
            dismiss(animated: true)
        }else{
            let meVC = storyboard!.instantiateViewController(identifier: kMeVCID) { coder in
                MeVC(coder: coder, user: user)
            }
            meVC.isFromNote = true
            meVC.modalPresentationStyle = .fullScreen
            present(meVC, animated: true)
        }
    }
    
    @objc func goToMeVC(_ tap: UIPassableTapGestureRecognizer){
        let user = tap.passObj
        noteToMeVC(user)
    }
}
