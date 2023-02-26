//
//  EditProfileTableVC.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/26.
//

import UIKit

class EditProfileTableVC: UITableViewController {

    
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
    // 性别选项 代码构写
    lazy var textfield : UITextField = {
        let textfield = UITextField(frame: .zero)
        //自定义软键盘
        textfield.inputView = view
        return textfield
    }()
    
    lazy var genderPickerView: UIStackView = {
        let cancelBtn = UIButton()
        setToolBarBtn(cancelBtn, title: "取消", color: .secondaryLabel)
        let doneBtn = UIButton()
        setToolBarBtn(doneBtn, title: "完成", color: mainColor)
        
        let stackView = UIStackView(arrangedSubviews: [cancelBtn,doneBtn])
        
        stackView.distribution = .equalSpacing
        
        let pickerView = UIPickerView()
        //约束
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        //调用
        pickerView.dataSource = self
        pickerView.delegate = self
        
        
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    @IBAction func back(_ sender: Any) {
    }
    
    private func setToolBarBtn(_ btn: UIButton , title:String , color: UIColor){
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        btn.setTitleColor(color, for: .normal)
        btn.largeContentImageInsets = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
    }
    
}

extension EditProfileTableVC: UIPickerViewDelegate , UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        <#code#>
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        <#code#>
    }
    
    
}
