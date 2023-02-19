//
//  WaterfallVC.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/1/30.
//
import UIKit
import CHTCollectionViewWaterfallLayout
import XLPagerTabStrip
import LeanCloud

class WaterfallVC: UICollectionViewController {
    
    var channel = ""
    //草稿相关数据
    var isMyDraft = false
    var draftNotes: [DraftNote] = []
    //首页相关数据
    var notes: [LCObject] = []
  

    override func viewDidLoad() {
        super.viewDidLoad()

        config()
        getNotes()
        getDraftNotes()
        
    }

    
    @IBAction func dismissDraftNotesVC(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

// MARK: - CHTCollectionViewDelegateWaterfallLayout
extension WaterfallVC: CHTCollectionViewDelegateWaterfallLayout{
    //存在的意义就是设定一个cell 的 size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //cell的宽度
        let cellW = (screenRect.width - kWaterfallPadding * 3) / 2
        //cell的高度
        var cellH: CGFloat = 0
        if isMyDraft{
            let draftNote = draftNotes[indexPath.item]
            //imageSize是图片实际大小
            let imageSize = UIImage(draftNote.coverPhoto)?.size ?? imagePH.size
            let imageH = imageSize.height
            let imageW = imageSize.width
            //用宽高比 * cell的宽度
            let imageRatio = imageH / imageW
            cellH = cellW * imageRatio + kDraftNoteWaterfallCellBottomViewH
        }else{
            let note = notes[indexPath.item]
            let coverPhotoRatio = CGFloat(note.getExactDoubelVal(kCoverPhotoRatioCol))
            cellH = cellW * coverPhotoRatio + kWaterfallCellBottomViewH
        }
        
        return CGSize(width: cellW, height: cellH)
    }
}

extension WaterfallVC: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: channel)
    }
}
