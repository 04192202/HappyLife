//
//  NoteDetailVC-Config.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/17.
//

import Foundation
import ImageSlideshow
import GrowingTextView

extension NoteDetailVC{
    func config(){
        
        imageSlideshow.zoomEnabled = true
        imageSlideshow.circular = false
        imageSlideshow.contentScaleMode = .scaleAspectFill
        imageSlideshow.activityIndicator = DefaultActivityIndicator()
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .systemGray
        pageControl.currentPageIndicatorTintColor = mainColor
        imageSlideshow.pageIndicator = pageControl
        
        //textView (评论)
        textView.textContainerInset = UIEdgeInsets(top: 11.5, left: 16, bottom: 11.5, right: 16)
        textView.delegate = self
        //添加观察者,监听键盘的弹出和收起
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        tableView.register(UINib(nibName: "CommentView", bundle: nil), forHeaderFooterViewReuseIdentifier: kCommentViewID)
        
    }
    
    func adjustTableHeaerViewHeight(){
        //计算出tableHeaderView里内容的总height--固定用法(开销较大,不可过度使用)
        let height = tableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        //取出初始frame值,待会把里面的height替换成上面计算的height,其余不替换
        var frame = tableHeaderView.frame
        //一旦tableHeaderView的height已经是实际height了,则不能也没必要继续赋值frame了.
        //需判断,否则更改tableHeaderView的frame会再次触发viewDidLayoutSubviews,进而进入死循环
        if frame.height != height{
            frame.size.height = height//替换成实际height
            tableHeaderView.frame = frame//重新赋值frame,即可改变tableHeaderView的布局(实际就是改变height)
        }
    }
    
}
//自增长textView内文字换行时高度增长的动画
extension NoteDetailVC: GrowingTextViewDelegate{
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}


extension NoteDetailVC{
    @objc private func keyboardWillChangeFrame(_ notification: Notification){
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            //键盘的当前高度(弹起时大于0,收起时为0)
            let keyboardH = screenRect.height - endFrame.origin.y
            
            if keyboardH > 0{
                view.insertSubview(overlayView, belowSubview: textViewBarView)//给背景加黑色透明遮罩
            }else{
                overlayView.removeFromSuperview()//移除黑色透明遮罩
                textViewBarView.isHidden = true
            }
            
            textViewBarBottomConstraint.constant = -keyboardH
            //软键盘弹出效果
            view.layoutIfNeeded()
        }
    }
}
