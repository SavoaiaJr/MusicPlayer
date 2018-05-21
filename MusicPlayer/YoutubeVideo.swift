//
//  YoutubeVideo.swift
//  MusicPlayer
//
//  Created by Madalin Savoaia on 5/19/18.
//  Copyright © 2018 Madalin Savoaia. All rights reserved.
//

import UIKit

class YoutubeVideo: NSObject {
    var name: String = ""
    var descript: String = ""
    var videoId: String = ""
    var thumbnailLink: String = ""
    
    init(name: String, descript: String, videoId: String, thumbnailLink: String) {
        self.name = name
        self.descript = descript
        self.videoId = videoId
        self.thumbnailLink = thumbnailLink
    }
}
