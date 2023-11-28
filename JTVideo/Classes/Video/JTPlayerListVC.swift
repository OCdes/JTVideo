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
    
    lazy var currentPlayer: JTPlayerView = {
        let cp = JTPlayerView(frame: CGRectZero)
        cp.controlBar.isListMode = true
        return cp
    }()
    
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
    
    var previosBtn: UIButton?
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.addSubview(listView)
        listView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        listView.reloadData()
    }
    
    deinit {
        self.currentPlayer.destroyPlayerView()
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
        cell.coverImgv.kf.setBackgroundImage(with: URL(string: model.CoverURL), for: .normal)
        cell.coverImgv.tag = indexPath.row
        cell.coverImgv.addTarget(self, action: #selector(playBtnClicked(btn:)), for: .touchUpInside)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    @objc func playBtnClicked(btn: UIButton) {
        if previosBtn != nil && previosBtn != btn {
            let cell = listView.cellForRow(at: IndexPath(row: previosBtn!.tag, section: 0)) as! PlayerListCell
            cell.playBtn.isHidden = btn.isSelected
            self.currentPlayer.player.clearScreen()
        }
        btn.isSelected = !btn.isSelected
        previosBtn = btn
        let cell = listView.cellForRow(at: IndexPath(row: btn.tag, section: 0)) as! PlayerListCell
        cell.playBtn.isHidden = btn.isSelected
        let model = dataArr[btn.tag]
        if btn.isSelected {
            if model.source != self.currentPlayer.urlSource {
//                self.currentPlayer.showLayer = cell.coverImgv
                self.currentPlayer.isUserInteractionEnabled = false
                self.currentPlayer.urlSource = model.source
                self.currentPlayer.controlBar.isListMode = true
                self.currentPlayer.player.isAutoPlay = true
            } else {
                self.currentPlayer.player.start()
            }
            
        } else {
            cell.playBtn.isHidden = false
            self.currentPlayer.player.pause()
        }
        
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

class PlayerListCell: UITableViewCell {
    lazy var coverImgv: UIButton = {
        let cv = UIButton()
        cv.contentMode = .scaleAspectFill
        cv.clipsToBounds = true
        return cv
    }()
    lazy var playBtn: UIImageView = {
        let pb = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        pb.image = JTVideoBundleTool.getBundleImg(with: "JTVideoPlay")
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
