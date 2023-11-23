//
//  JTPlayerListVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/11/22.
//

import UIKit

open class JTPlayerListVC: UIViewController {
    
    var ori: UIInterfaceOrientationMask = .portrait {
        didSet {
            if ori.contains(.portrait) {
                
            } else {
                UIDevice.current.setValue(UIInterfaceOrientationMask.landscapeLeft, forKey: "orientation")
            }
        }
    }
    
    var currentPlayer: JTPlayerView?
    
    lazy var listView: UITableView = {
        let listView = UITableView(frame: CGRectZero, style: .grouped)
        listView.delegate = self
        listView.dataSource = self
        listView.estimatedRowHeight = 220
        listView.register(PlayerListCell.self, forCellReuseIdentifier: "PlayerListCell")
        return listView
    }()
    
    var dataArr: [ViewHomeListModel] {
        let vm = VideoHomeViewModel()
        vm.refreshData(scrollView: UIScrollView())
        return vm.dataArr as! [ViewHomeListModel]
    }
    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.addSubview(listView)
        listView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        listView.reloadData()
    }
}

extension JTPlayerListVC: JTPlayerViewDelegate {
    func requireFullScreen(fullScreen: Bool) {
        
    }
}

extension JTPlayerListVC: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerListCell", for: indexPath) as! PlayerListCell
        cell.titleLa.text = model.Title
        cell.coverImgv.kf.setImage(with: URL(string: model.CoverURL))
        cell.jt_playerView = cell.coverImgv
        cell.jt_playerSource = model.source
        cell.playBtn.tag = indexPath.row
        return cell
    }
    
    @objc func playBtnClicked(btn: UIButton) {
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击了\(indexPath.row)")
        let cell = tableView.cellForRow(at: indexPath) as! PlayerListCell
        cell.playBtn.isSelected = !cell.playBtn.isSelected
        cell.playBtn.isHidden = cell.playBtn.isSelected
        
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PlayerListCell
        cell.playBtn.isSelected = false
        cell.playBtn.isHidden = false
        
    }
}

class PlayerListCell: UITableViewCell {
    lazy var coverImgv: UIImageView = {
        let cv = UIImageView()
        cv.contentMode = .scaleAspectFill
        return cv
    }()
    lazy var playBtn: UIButton = {
        let pb = UIButton.init(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        pb.setImage(JTVideoBundleTool.getBundleImg(with: "JTVideoPlay"), for: .normal)
        return pb
    }()
    lazy var titleLa: UILabel = {
        let tl = UILabel()
        tl.font = UIFont.systemFont(ofSize: 14)
        tl.numberOfLines = 2
        return tl
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(coverImgv)
        coverImgv.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0))
        }
        
        
        contentView.addSubview(playBtn)
        playBtn.snp_makeConstraints { make in
            make.center.equalTo(self.coverImgv)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        
        contentView.addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.top.equalTo(self.coverImgv.snp_bottom)
            make.left.equalTo(self.contentView).offset(20)
            make.right.equalTo(self.contentView).offset(-20)
            make.bottom.equalTo(self.contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
