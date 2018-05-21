//
//  SongsManager.swift
//  MusicPlayer
//
//  Created by Madalin Savoaia on 5/19/18.
//  Copyright © 2018 Madalin Savoaia. All rights reserved.
//

import UIKit

typealias Song = Dictionary<String, String>
typealias Songs = Array<Song>

class SongsManager: NSObject {
    static let sharedInstance = SongsManager()
    static let musicArrayKey = "music"
    func saveSong(data: Data, youtubeVideo: YoutubeVideo) -> Bool {
        let fileManager = FileManager.default
        let userDefaults = UserDefaults.standard
        var music = userDefaults.array(forKey: SongsManager.musicArrayKey) ?? []
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let songUrl = documentDirectory.appendingPathComponent(youtubeVideo.name)
            try data.write(to: songUrl)
            
            // create music dictionary object
            var musicDictionary = Dictionary<String, String>()
            musicDictionary.updateValue(youtubeVideo.name, forKey: "name")
            musicDictionary.updateValue(songUrl.absoluteString, forKey: "url")
            
            // save music dictionary to music array from user defaults to keep the references to mp3s
            
            music.append(musicDictionary)
            userDefaults.set(music, forKey: "music")
            userDefaults.synchronize()
            
            return true
        } catch {
            print("Error -> \(error)")
        }
        return false
    }
    
    func getAllSongs() -> Songs {
        let userDefaults = UserDefaults.standard
        guard let music  = userDefaults.array(forKey: SongsManager.musicArrayKey) as? Songs else {return Songs()}
        
        return music
    }
}
