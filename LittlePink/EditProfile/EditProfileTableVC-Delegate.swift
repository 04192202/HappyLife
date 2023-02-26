//
//  EditProfileTableVC-Delegate.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/26.
//

import Foundation
import PhotosUI

extension EditProfileTableVC{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            var config = PHPickerConfiguration()
            config.filter = .images
            config.selectionLimit = 1
            
            let vc = PHPickerViewController(configuration: config)
            vc.delegate = self
            present(vc, animated: true)
            
        case 1: showTextHUD("和修改简介一样")
        default:
            break
        }
    }
}