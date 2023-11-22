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
        cell.playerView.urlSource = ""
        cell.playerView.tag = indexPath.row
        cell.playerView.delegate = self
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击了\(indexPath.row)")
        let cell = tableView.cellForRow(at: indexPath) as! PlayerListCell
        cell.playBtn.isSelected = !cell.playBtn.isSelected
        cell.playBtn.isHidden = cell.playBtn.isSelected
        cell.playerView.controlBar.playerBtnClicked()
        if let player = self.currentPlayer, player != cell.playerView {
            player.controlBar.playerBtnClicked()
        }
        currentPlayer = cell.playerView
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PlayerListCell
        cell.playBtn.isSelected = false
        cell.playBtn.isHidden = false
        cell.playerView.controlBar.playerBtnClicked()
    }
}

class PlayerListCell: UITableViewCell {
    lazy var playerView: JTPlayerView = {
        let pv = JTPlayerView.init(frame: CGRect.zero)
        pv.isUserInteractionEnabled = false
        pv.controlBar.isListMode = true
        return pv
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
        contentView.addSubview(playerView)
        playerView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0))
        }
        
        
        contentView.addSubview(playBtn)
        playBtn.snp_makeConstraints { make in
            make.center.equalTo(self.playerView)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        
        contentView.addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.top.equalTo(self.playerView.snp_bottom)
            make.left.equalTo(self.contentView).offset(20)
            make.right.equalTo(self.contentView).offset(-20)
            make.bottom.equalTo(self.contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
