//
//  NoteEditVC.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/1/31.
//

import UIKit


class NoteEditVC: UIViewController {
    
    var draftNote: DraftNote?
    //闭包再重新编辑草稿后传入到本地
    var updateDraftNoteFinished: (() -> ())?
    
    var photos = [UIImage(named: "1")!, UIImage(named: "2")!]
    
    //var videoURL: URL? = Bundle.main.url(forResource: "TV", withExtension: "mp4")
    var videoURL: URL?
    
    var channel = ""
    var subChannel = ""
    var poiName = ""
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var photoCollectionview: UICollectionView!
    @IBOutlet weak var titleCountLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var channelIcon: UIImageView!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var channelPlaceholderLabel: UILabel!
    @IBOutlet weak var poiNameLabel: UILabel!
    @IBOutlet weak var poiNameIcon: UIImageView!
    
    //计算属性
    var photoCount : Int {photos.count}
    var isVideo : Bool {videoURL != nil}
    var textViewIAView: TextViewIAView{ textView.inputAccessoryView as! TextViewIAView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    
        setUI()
     
    }
    
    @IBAction func TFEditBegin(_ sender: Any) { titleCountLabel.isHidden = false }
    
    @IBAction func TFEditEnd(_ sender: Any) { titleCountLabel.isHidden = true }
    //点击软键盘的完成按钮收起软键盘\
    @IBAction func TFEndOnExit(_ sender: Any) { }

    @IBAction func TFEditChanged(_ sender: Any) { handleTFEditChanged() }
        
        
    // MARK: - 待做
    //存草稿和发布笔记之前需判断当前用户输入的正文文本数量,看是否大于最大可输入数量
    @IBAction func saveDraftNote(_ sender: Any) {
        
        guard isValidateNote() else { return }
        
        if let draftNote = draftNote{
            updateDraftNote(draftNote)
        }else{
            createDraftNote()
        }
    }
        
    
    @IBAction func postNote(_ sender: Any) {
        guard isValidateNote() else { return }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let channelVC = segue.destination as? ChannelVC{
            view.endEditing(true)
            channelVC.PVDelegate = self
        }else if let poiVC = segue.destination as? POIVC{
            poiVC.delegate = self
            poiVC.poiName = poiName
        }
    }
    
}
// MARK: - UITextViewDelegate
extension NoteEditVC: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        guard textView.markedTextRange == nil else { return }
        textViewIAView.currentTextCount = textView.text.count
    }
}
// MARK: - ChannelVCDelegate
extension NoteEditVC: ChannelVCDelegate{
    func updateChannel(channel: String, subChannel: String) {
        //数据
        self.channel = channel
        self.subChannel = subChannel
        //UI
        updateChannelUI()
    }
}
// MARK: - POIVCDelegate
extension NoteEditVC: POIVCDelegate{
    func updatePOIName(_ poiName: String) {
        //数据
        if poiName == kPOIsInitArr[0][0]{
            self.poiName = ""
        }else{
            self.poiName = poiName
        }
        //UI
        updatePOINameUI()
    }
}

