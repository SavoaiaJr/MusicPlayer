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
    
    func removeSong(index: Int) {
        let fileManager = FileManager.default
        let userDefaults = UserDefaults.standard
        
        var songs = getAllSongs()
        let song = songs[index]
    
        guard let name = song["name"] else {return}
        
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let songUrl = documentDirectory.appendingPathComponent(name)
            
            try fileManager.removeItem(at: songUrl)
            print("\(name) was successfully removed.")
        } catch {
            print("Error -> \(error)")
        }
        
        songs.remove(at: index)
        userDefaults.set(songs, forKey: "music")
        userDefaults.synchronize()
        
    }
    
    func getAllSongs() -> Songs {
        let userDefaults = UserDefaults.standard
        guard let music  = userDefaults.array(forKey: SongsManager.musicArrayKey) as? Songs else {return Songs()}
        
        return music
    }
    
    func getFirstSong() -> Song? {
        let songs = SongsManager.sharedInstance.getAllSongs()
        guard let song = songs.first else {
            return nil
        }
        
        return song
    }
}
