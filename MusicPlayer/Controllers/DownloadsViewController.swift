//
//  DownloadsViewController.swift
//  MusicPlayer
//
//  Created by Madalin Savoaia on 5/19/18.
//  Copyright © 2018 Madalin Savoaia. All rights reserved.
//

import UIKit
import AVFoundation

class DownloadsViewController: UIViewController
{

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var playerView: SmartPlayerView!
    
    
    
    var songs: Songs = Songs()
    var songNumber = 0
    var selectedSongIndex: Int = 0
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        playerView.delegate = self
        songs = SongsManager.sharedInstance.getAllSongs()
        tableView.reloadData()
    }
    
    func playCurrentSong() {
        if songs.count > 0  {
            let song = songs[selectedSongIndex]
            guard let name = song["name"] else {return}
            guard let urlPath = song["url"] else {return}
            guard let url = URL(string: urlPath) else {return}
            
            Player.sharedInstance.stop()
            Player.sharedInstance.delegate = self
            let succeed = Player.sharedInstance.play(url: url)
            
            if succeed == true {
                prepareSmartPlayerView(name: name)
                print("Melodia \(name) este redata cu succes")
            } else {
                print("Melodia \(name) nu poate fi redata")
            }
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func getSecondsToHoursMinutesSeconds (seconds:Int) -> String {
        let (h, m, s) = secondsToHoursMinutesSeconds (seconds: seconds)
        return "\(h):\(m):\(s)"
    }
    
    @objc func updateCurrentPlayingTime() {
        guard let currentTime = Player.sharedInstance.audioPlayer?.currentTime else {return}
        playerView.currentTimeLabel.text = getSecondsToHoursMinutesSeconds(seconds: Int(currentTime))
        playerView.slider.value = Float(currentTime)
    }
    
    func prepareSmartPlayerView(name: String) {
        playerView.songLabel.text = name
        playerView.currentTimeLabel.text = getSecondsToHoursMinutesSeconds(seconds: 0)
        
        if let duration = Player.sharedInstance.audioPlayer?.duration {
            playerView.totalTimeLabel.text = getSecondsToHoursMinutesSeconds(seconds: Int(duration))
            playerView.slider.maximumValue = Float(duration)
        }
        
        playerView.slider.minimumValue = 0.0
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCurrentPlayingTime), userInfo: nil, repeats: true)
    }
    
    func initSmartPlayerViewValues() {
        timer?.invalidate()
        let zeroString = getSecondsToHoursMinutesSeconds(seconds: 0)
        playerView.currentTimeLabel.text = zeroString
        playerView.totalTimeLabel.text = zeroString
        playerView.songLabel.text = "Song Name"
        playerView.slider.value = 0.0
    }
    
    func getPreviousSongIndex() -> Int {
        var previousSongIndex = songs.count - 1
        
        if selectedSongIndex > 0 {
            previousSongIndex = selectedSongIndex - 1
        }
        
        return previousSongIndex
    }
    
    func getNextSongIndex() -> Int {
        var nextSongIndex = 0
        
        if selectedSongIndex < songs.count - 1 {
            nextSongIndex = selectedSongIndex + 1
        }
        
        return nextSongIndex
    }
    
//    override func remoteControlReceived(with event: UIEvent?) {
//        guard let event = event else {return}
//        
//        if event.type == .remoteControl {
//            if event.subtype == .remoteControlNextTrack {
//                
//            } else if event.subtype == .remoteControlPreviousTrack {
//                rewind()
//            } else if event.subtype == .remoteControlNextTrack {
//                fastforward()
//            } else if event.subtype == .remoteControlPlay {
//                play()
//            } else if event.subtype == .remoteControlPause {
//                play()
//            } else if event.subtype == .remoteControlStop {
//                play()
//            }
//        }
//    }
}

extension DownloadsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let song = songs[indexPath.row]
        let songName = song["name"] ?? "Name error"
        let songIndex = indexPath.row + 1
        cell.textLabel?.text = songIndex.description + " - " + songName
        
        return cell
    }
}

extension DownloadsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSongIndex = indexPath.row
        Player.sharedInstance.stop()
        initSmartPlayerViewValues()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Player.sharedInstance.stop()
            initSmartPlayerViewValues()
            SongsManager.sharedInstance.removeSong(index: indexPath.row)
            setup()
        }
    }
}

extension DownloadsViewController: SmartPlayerViewDelegate {
    func sliderValueChanged(value: Float) {
        Player.sharedInstance.scrollTo(value: value)
    }
    
    func rewind() {
        initSmartPlayerViewValues()
        selectedSongIndex = getPreviousSongIndex()
        let indexPath = IndexPath(row: selectedSongIndex, section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
        playCurrentSong()
    }
    
    func play() {
        if Player.sharedInstance.isPlaying() == true {
            Player.sharedInstance.pause()
        } else if Player.sharedInstance.isPausing() == true {
            Player.sharedInstance.unPause()
        } else {
            playCurrentSong()
        }
    }
    
    func fastforward() {
        initSmartPlayerViewValues()
        selectedSongIndex = getNextSongIndex()
        let indexPath = IndexPath(row: selectedSongIndex, section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
        playCurrentSong()
    }
}

extension DownloadsViewController: PlayerDelegate {
    
    func didFinishPlaying() {
        initSmartPlayerViewValues()
        fastforward()
    }
}
