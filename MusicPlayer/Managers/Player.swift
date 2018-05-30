//
//  Player.swift
//  MusicPlayer
//
//  Created by Madalin Savoaia on 5/19/18.
//  Copyright © 2018 Madalin Savoaia. All rights reserved.
//

import UIKit
import AVFoundation

protocol PlayerDelegate {
    func didFinishPlaying()
}


class Player: NSObject {
    static let sharedInstance = Player()
    var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    private var inPause = false

    var delegate: PlayerDelegate?

    func play(url: URL) -> Bool {
        do {
            stop()
            let mp3Data = try Data(contentsOf: url)
            print("mp3Data a fost gasita")
            audioPlayer = try AVAudioPlayer(data: mp3Data)
            audioPlayer?.delegate = self
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
        inPause = false
    }
    
    func rewind() {
        
    }
    
    func fastForward() {
        
    }
    
    func isPlaying() -> Bool {
        guard let audioPlayer = audioPlayer else {
            return false
        }
        
        return audioPlayer.isPlaying
    }
    
    func isPausing() -> Bool {
        return inPause
    }
    
    func scrollTo(value: Float) {
        audioPlayer?.pause()
        audioPlayer?.currentTime = TimeInterval(value)
        audioPlayer?.play()
    }
    
    func pause() {
        audioPlayer?.pause()
        inPause = true
    }
    
    func unPause() {
        audioPlayer?.play()
        inPause = false
    }
    
}

extension Player: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if player == audioPlayer {
            delegate?.didFinishPlaying()
        }
    }
}
