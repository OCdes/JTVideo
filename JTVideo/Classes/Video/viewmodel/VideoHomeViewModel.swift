//
//  VideoHomeViewModel.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/10/31.
//

import UIKit

class VideoHomeViewModel: JTVideoBaseViewModel {
    @objc dynamic var dataArr:[Any] = []
    
    override init() {
        super.init()
        
    }
    
    func refreshData(scrollView: UIScrollView) {
        let arr = [
            ["VideoId":"0","source":"http://player.alicdn.com/video/aliyunmedia.mp4","CoverURL": "http://vod-download.cn-shanghai.aliyuncs.com/video-list-img/cctv5plus.png","Title": "ARGENTINA SCORE FOOTBALL PERFECTION IN ATHENS","Duration": "05:37","Description": "The star-studded Argentina football team went on a formidable run to secure an historic gold medal at the Olympic Games Athens 2004."
            ], [
                "VideoId": "1",
                "source": "http://player.alicdn.com/video/aliyunmedia.mp4",
                "CoverURL": "http://vod-download.cn-shanghai.aliyuncs.com/video-list-img/cctv5.jpeg",
                "Title": "THE YOUNGEST OLYMPIC CHAMPIONS IN HISTORY",
                "Duration": "04:11",
                "Description": "From teenage divers to Sonja Henie and the boy with no name - a closer look at the youngest champions in Olympic history."
            ], [
                "VideoId": "2",
                "source": "http://player.alicdn.com/video/aliyunmedia.mp4",
                "CoverURL": "http://vod-download.cn-shanghai.aliyuncs.com/video-list-img/cctv11.jpeg",
                "Title": "LAVILLENIE CLAIMS POLE VAULT RECORD IN LONDON 2012",
                "Duration": "05:00",
                "Description": "French pole vaulter Renaud Lavillenie loves motorsport and drives to reach new heights, as shown by his success at London 2012 Olympics."
            ], [
                "VideoId": "3",
                "source": "http://player.alicdn.com/video/aliyunmedia.mp4",
                "CoverURL": "http://vod-download.cn-shanghai.aliyuncs.com/video-list-img/cctv13.jpeg",
                "Title": "UNRIVALLED FISCHER'S REMARKABLE GOLD MEDAL RUN",
                "Duration": "05:46",
                "Description": "A closer look at German veteran kayaker Birgit Fischer, who competed at six Olympic Games and won an incredible eight gold medals."
            ], [
                "VideoId": "4",
                "source": "http://player.alicdn.com/video/aliyunmedia.mp4",
                "CoverURL": "http://vod-download.cn-shanghai.aliyuncs.com/video-list-img/cctv4.jpeg",
                "Title": "DEVERS PIPS OTTEY IN DRAMATIC 100M IN ATLANTA 1996",
                "Duration": "04:19",
                "Description": "Gail Devers edges out Merlene Ottey in a thrilling photo finish Olympic 100m final at Atlanta 1996 that could barely have been any closer."
            ]
        ];
        if let a  = [ViewHomeListModel].deserialize(from: arr) {
            self.dataArr = a as [Any]
        }
        
    }
}


class ViewHomeListModel: JTVideoBaseModel {
    var VideoId: String = ""
    var source: String = "http://player.alicdn.com/video/aliyunmedia.mp4"
    var CoverURL: String = ""
    var Title: String = ""
    var Duration: String = ""
    var Description: String = ""
}
