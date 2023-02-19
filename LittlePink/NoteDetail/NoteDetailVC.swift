//
//  NoteDetailVC.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/17.
//

import UIKit
import ImageSlideshow
import LeanCloud
import FaveButton
import GrowingTextView

class NoteDetailVC: UIViewController {

    var note: LCObject
    var isLikeFromWaterfallCell = false
    var delNoteFinished: (() -> ())? 
    //上方bar
    @IBOutlet weak var authorAvatarBtn: UIButton!
    @IBOutlet weak var authorNickNameBtn: UIButton!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var shareOrMoreBtn: UIButton!
    //tableHeaderView
    @IBOutlet weak var imageSlideshow: ImageSlideshow!
    @IBOutlet weak var imageSlideshowHeight: NSLayoutConstraint!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    //这里不使用UITextView是因其默认是滚动状态,不太方便搞成有多少就显示多少行的状态,开发一般是用Label
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var channelBtn: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    //整个tableView
    @IBOutlet weak var tableView: UITableView!
    
    //下方bar(点赞收藏评论)
    @IBOutlet weak var likeBtn: FaveButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var favBtn: FaveButton!
    @IBOutlet weak var favCountLabel: UILabel!
    @IBOutlet weak var commentCountBtn: UIButton!
    
    @IBOutlet weak var textViewBarView: UIView!
    
    @IBOutlet weak var textView: GrowingTextView!
    
    
    
    
    var likeCount = 0{
        didSet{
            likeCountLabel.text = likeCount == 0 ? "点赞" : likeCount.formattedStr
        }
    }
    
    var currentLikeCount = 0
    
    var favCount = 0{
        didSet{
            favCountLabel.text = favCount == 0 ? "收藏" : favCount.formattedStr
        }
    }
    
    var currentFavCount = 0
    
    
    var commentCount = 0{
        didSet{
            commentCountLabel.text = "\(commentCount)"
            commentCountBtn.setTitle(commentCount == 0 ? "评论" : commentCount.formattedStr, for: .normal)
        }
    }
    
    
    //计算属性
    var author : LCUser?{ note.get(kAuthorCol) as? LCUser }
    var isLike : Bool { likeBtn.isSelected }
    var isFav : Bool { favBtn.isSelected }
    var isReadMyNote: Bool {
        if let user = LCApplication.default.currentUser, let author = author, user == author{
            return true
        }else{
            return false
        }
    }
    
    
    init?(coder:NSCoder, note:LCObject) {
        self.note = note
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("必须传一些参数进来以构造本对象,不能单纯的用storyboard!.instantiateViewController构造本对象")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        
        imageSlideshow.setImageInputs([
            ImageSource(image: UIImage(named: "1")!),
            ImageSource(image: UIImage(named: "2")!),
            ImageSource(image: UIImage(named: "3")!)
        ])
        let imageSize = UIImage(named: "1")!.size
        imageSlideshowHeight.constant = (imageSize.height / imageSize.width) * screenRect.width
        
        setUI()
    }
    //高度自适应
    //动态计算tableHeaderView的height(放在viewdidappear的话会触发多次),相当于手动实现了estimate size(目前cell已配备这种功能)
    override func viewDidLayoutSubviews() {
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
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    
    @IBAction func shareOrMore(_ sender: Any) { shareOrMore() }
    
    //点赞
    @IBAction func like(_ sender: Any) { like() }
    //收藏
    @IBAction func fav(_ sender: Any) { fav()   }
    
}
