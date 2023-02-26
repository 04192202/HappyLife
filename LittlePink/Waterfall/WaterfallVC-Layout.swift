//
//  WaterfallVC-Layout.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/24.
//

import Foundation
import CHTCollectionViewWaterfallLayout

// MARK: - CHTCollectionViewDelegateWaterfallLayout
extension WaterfallVC: CHTCollectionViewDelegateWaterfallLayout{
    //存在的意义就是设定一个cell 的 size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //cell的宽度
        let cellW = (screenRect.width - kWaterfallPadding * 3) / 2
        //cell的高度
        var cellH: CGFloat = 0
        
        if isMyDraft, indexPath.item == 0{
            
            cellH = 100
            
        }else if isDraft{
            let draftNote = draftNotes[indexPath.item]
            //imageSize是图片实际大小
            let imageSize = UIImage(draftNote.coverPhoto)?.size ?? imagePH.size
            let imageH = imageSize.height
            let imageW = imageSize.width
            //用宽高比 * cell的宽度
            let imageRatio = imageH / imageW
            cellH = cellW * imageRatio + kDraftNoteWaterfallCellBottomViewH
        }else{
            let offset = isMyDraft ? 1 : 0
            let note = notes[indexPath.item - offset]
            let coverPhotoRatio = CGFloat(note.getExactDoubelVal(kCoverPhotoRatioCol))
            cellH = cellW * coverPhotoRatio + kWaterfallCellBottomViewH
        }
        
        return CGSize(width: cellW, height: cellH)
    }
}
