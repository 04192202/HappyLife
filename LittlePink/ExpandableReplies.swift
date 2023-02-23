//
//  ExpandableReplies.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/22.
//

import Foundation
import LeanCloud
//可展开的回复
struct ExpandableReplies {
    var isExpanded = false
    var replies: [LCObject]
}
