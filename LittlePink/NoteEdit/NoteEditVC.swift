//
//  NoteEditVC.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/1/31.
//

import UIKit


class NoteEditVC: UIViewController {
    
    var photos = [UIImage(named: "1"),UIImage(named: "2")]
    
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
        

   
        
        
    }
    
    @IBAction func TFEditBegin(_ sender: Any) {
        
        titleCountLabel.isHidden = false
    }
    
    @IBAction func TFEditEnd(_ sender: Any) {
        
        titleCountLabel.isHidden = true
    }
    //点击软键盘的完成按钮收起软键盘\
    @IBAction func TFEndOnExit(_ sender: Any) {
    }

    
    @IBAction func TFEditChanged(_ sender: Any) {
        
        // MARK: - 发布栏标题
        //当前有高亮文本时(拼音键盘)return
        guard titleTextField.markedTextRange == nil else { return }
        
        //用户输入完字符后进行判断,若大于最大字符数,则截取前面的文本(if里面第一行)
        if titleTextField.unwrappedText.count > kMaxNoteTitleCount{
        //prefix截取
            titleTextField.text = String(titleTextField.unwrappedText.prefix(kMaxNoteTitleCount))
            
            showTextHUD("标题最多输入\(kMaxNoteTitleCount)字")
            
            //用户粘贴文本后的光标位置,默认会跑到粘贴文本的前面,此处改成末尾
            DispatchQueue.main.async {
                let end = self.titleTextField.endOfDocument //文末
                // textRange 光标
                self.titleTextField.selectedTextRange = self.titleTextField.textRange(from: end, to: end)
            }
        }
        titleCountLabel.text = "\(kMaxNoteTitleCount - titleTextField.unwrappedText.count)"

    }
    
    //存草稿和发布笔记之前需判断当前用户输入的正文文本数量,看是否大于最大可输入数量
    @IBAction func saveDraftNote(_ sender: Any) {
        
        guard textViewIAView.currentTextCount <= kMaxNoteTextCount else{
            showTextHUD("正文最多输入\(kMaxNoteTextCount)字")
            return
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //面向对象的方法存数据
        let draftNote = DraftNote (context: context)
        //coredata 定义字段和全局一样
        draftNote.coverPhoto = photos[0]?.pngData()
        draftNote.title = titleTextField.exacText
        draftNote.text = textView.exacText
        draftNote.channel = channel
        draftNote.subChannel = subChannel
        draftNote.poiName = poiName
        draftNote.updateAt = Date()
        appDelegate.saveContext()
    }
    
    @IBAction func postNote(_ sender: Any) {
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
        channelIcon.tintColor = blueColor
        channelLabel.text = subChannel
        channelLabel.textColor = blueColor
        channelPlaceholderLabel.isHidden = true
    }
}

// MARK: - POIVCDelegate
extension NoteEditVC: POIVCDelegate{
    func updatePOIName(_ poiName: String) {
        //如果用户选择的是不选择位置，就为这个正向传值赋予一个空串
        if poiName == kPOIsInitArr[0][0]{
            self.poiName = ""
            //重置原来的UI
            poiNameIcon.tintColor = .label
            poiNameLabel.text = "添加地点"
            poiNameLabel.textColor = .label
        }else{
            //数据
            self.poiName = poiName
            //UI
            poiNameIcon.tintColor = blueColor
            poiNameLabel.text = poiName
            poiNameLabel.textColor = blueColor
        }
    }
}
