//
//  NoteDetailVC-TVDataSource.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/20.
//

import Foundation

extension NoteDetailVC: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        comments.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kReplyCellID, for: indexPath)
        cell.textLabel?.text = "我是对评论的回复"
        return cell
    }
    
}
