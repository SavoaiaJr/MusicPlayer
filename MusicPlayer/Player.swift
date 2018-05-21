//
//  Player.swift
//  MusicPlayer
//
//  Created by Madalin Savoaia on 5/19/18.
//  Copyright © 2018 Madalin Savoaia. All rights reserved.
//

import UIKit
import AVFoundation

class Player: NSObject {
    static let sharedInstance = Player()
    var audioPlayer: AVAudioPlayer?
    func play(url: URL) -> Bool {
        do {
            stop()
            let mp3Data = try Data(contentsOf: url)
            print("mp3Data a fost gasita")
            audioPlayer = try AVAudioPlayer(data: mp3Data)
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            UIApplication.shared.beginReceivingRemoteControlEvents()
            
            audioPlayer?.play()
            return true
        } catch {
            return false
        }
    }
    
    func stop() {
        audioPlayer?.stop()
    }
}
