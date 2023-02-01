//
//  NoteEditVC.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/1/31.
//

import UIKit
import YPImagePicker
import MBProgressHUD
import SKPhotoBrowser
import AVKit

class NoteEditVC: UIViewController {
    
    var photos = [UIImage(named: "1"),UIImage(named: "2")]
    
    var videoURL: URL?
    
    
    @IBOutlet weak var photoCollectionview: UICollectionView!
    
    //计算属性
    var photoCount : Int {photos.count}
    var isVideo : Bool {videoURL != nil}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension NoteEditVC :UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPhotoCellID, for: indexPath) as! PhotoCell
        cell.imageView.image = photos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let photoFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kPhotoFooterID, for: indexPath) as! PhotoFooter
            
            photoFooter.addPhotoBtn.addTarget(self, action:#selector(addPhoto) , for: .touchUpInside)
            
            return photoFooter
        default:
            fatalError("Footer Wrong !")
        }
        
    }
    
    
}
    
    
    
// MARK: - 发布预览图片
extension NoteEditVC : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isVideo{
            let playerVC = AVPlayerViewController()
            playerVC.player = AVPlayer(url: videoURL!)
            present(playerVC,animated: true)
            {
            playerVC.player?.play()
            }
        } else {
            var images :[SKPhoto] = []
            
            for photo in photos{
                images.append(SKPhoto.photoWithImage(photo!))
            }
            
            let brower = SKPhotoBrowser(photos: images, initialPageIndex: indexPath.item)
            brower.delegate = self
            SKPhotoBrowserOptions.displayAction = false
            SKPhotoBrowserOptions.displayDeleteButton = true
            present(brower,animated: true)
        }
    }
}
    // MARK: - SKPhotoBrowserDelegate 发布图片浏览删除
extension NoteEditVC : SKPhotoBrowserDelegate{
    func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void)) {
        photos.remove(at: index)
        photoCollectionview.reloadData()
        reload()
    }
}
   // MARK: - 监听

extension NoteEditVC{
    @objc private func addPhoto(){
        if photoCount < kMaxPhotoCount{
            var config = YPImagePickerConfiguration()
            
            // MARK: 通用配置
            config.albumName = Bundle.main.appName //存图片进相册App的'我的相簿'里的文件夹名称
            config.screens = [.library] //展示相册
            
            // MARK: 相册配置
            config.library.defaultMultipleSelection = true //是否可多选
            config.library.maxNumberOfItems = kMaxPhotoCount - photoCount //最大选取照片或视频数
            config.library.spacingBetweenItems = kSpacingBetweenItems //照片缩略图之间的间距
            
            // MARK: - Gallery(多选完后的展示和编辑页面)-画廊
            config.gallery.hidesRemoveButton = false //每个照片或视频右上方是否有删除按钮
            
            let picker = YPImagePicker(configuration: config)
            
            // MARK: 选完或按取消按钮后的异步回调处理（依据配置处理单个或多个）
            picker.didFinishPicking { [unowned picker] items, _ in
  
                for item in items {
                    if case let .photo(photo) = item{
                        self.photos.append(photo.image)
                    }
                }
                //重新加载datasource
                self.photoCollectionview.reloadData()
                
                picker.dismiss(animated: true)
            }
            
            present(picker, animated: true)
        }else{
           
            showTextHUD("最多只能选择\(kMaxPhotoCount)张照片")
        }
    }
}
