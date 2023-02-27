//
//  EditProfileTableVC.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/26.
//

import UIKit
import ActionSheetPicker_3_0
import LeanCloud

class EditProfileTableVC: UITableViewController {

    var user: LCUser!
    var delegate: EditProfileTableVCDelegate?
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    
    
    var avatar: UIImage?{
        didSet{
            DispatchQueue.main.async {
                self.avatarImageView.image = self.avatar
            }
        }
    }
    
    var nickName =  ""{
        didSet{
            nickNameLabel.text = nickName
        }
    }
    
    var gender = false{
        didSet{
            genderLabel.text = gender ? "男" : "女"
        }
    }
    
    var birth: Date?{
        didSet{
            if let birth = birth{
                birthLabel.text = birth.format(with: "yyyy-MM-dd")
            }else{
                birthLabel.text = "未填写"
            }
        }
    }
    
    var intro = ""{
        didSet{
            introLabel.text = intro.isEmpty ? "未填写" : intro
        }
    }
    
    // 性别选项 代码构写
    lazy var textfield : UITextField = {
        let textfield = UITextField(frame: .zero)
        //自定义软键盘
        textfield.inputView = view
        return textfield
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUI()
        
        //textfield.inputView = genderPickerView
        //tableView.addSubview(textfield)
        
    }

    
    @IBAction func back(_ sender: Any) {
        
        delegate?.updateUser(avatar, nickName, gender, birth, intro)
        dismiss(animated: true)
    }
    
    
//
//    lazy var genderPickerView: UIStackView = {
//        let cancelBtn = UIButton()
//        setToolBarBtn(cancelBtn, title: "取消", color: .secondaryLabel)
//        let doneBtn = UIButton()
//
//        setToolBarBtn(doneBtn, title: "完成", color: mainColor)
//
//        let toolBarView = UIStackView(arrangedSubviews: [cancelBtn,doneBtn])
//        toolBarView.distribution = .equalSpacing
//
//
//
//        let pickerView = UIPickerView()
//        pickerView.dataSource = self
//        pickerView.delegate = self
//
//        let genderPickerView = UIStackView(arrangedSubviews: [toolBarView,pickerView])
//        genderPickerView.frame.size.height = 150
//        genderPickerView.axis = .vertical
//        genderPickerView.spacing = 8
//        genderPickerView.backgroundColor = .secondarySystemGroupedBackground
//
//
//        return genderPickerView
//
//    }()
//    private func setToolBarBtn(_ btn: UIButton , title:String , color: UIColor){
//        btn.setTitle(title, for: .normal)
//        btn.titleLabel?.font = .systemFont(ofSize: 14)
//        btn.setTitleColor(color, for: .normal)
//        btn.largeContentImageInsets = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
//    }
    
}

//extension EditProfileTableVC: UIPickerViewDelegate , UIPickerViewDataSource{
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        2
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        ["男", "女"][row]
//    }
//
//}
