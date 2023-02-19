//
//  NoteDetailVC-Config.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/17.
//

import Foundation
import ImageSlideshow

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
    }
}
