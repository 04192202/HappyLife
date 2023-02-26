//
//  EditProfileTableVC-PHPickerVCDelegate.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/26.
//

import PhotosUI
//用户在选完头像照片后触发
extension EditProfileTableVC: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        //(\.itemProvider) [swiftUI用法]= { $0 itemProvider }
        //let itemProviders = results.map(\.itemProvider)
        //优化：
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self){
            
            itemProvider.loadObject(ofClass: UIImage.self){ [weak self ] (image,error) in
                //第一个slef 为 weak slef 弱引用解包的slef
                guard let self = self ,let image = image as? UIImage else { return }
                    self.avatar = image
            }
        }
    }
}
