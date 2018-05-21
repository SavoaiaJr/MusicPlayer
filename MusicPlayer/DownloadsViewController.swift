//
//  DownloadsViewController.swift
//  MusicPlayer
//
//  Created by Madalin Savoaia on 5/19/18.
//  Copyright © 2018 Madalin Savoaia. All rights reserved.
//

import UIKit

class DownloadsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var songs: Songs = Songs()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        songs = SongsManager.sharedInstance.getAllSongs()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DownloadsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let song = songs[indexPath.row]
        
        cell.textLabel?.text = song["name"] ?? "Name error"
        
        return cell
    }
}

extension DownloadsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = songs[indexPath.row]
        guard let name = song["name"] else {return}
        guard let urlPath = song["url"] else {return}
        guard let url = URL(string: urlPath) else {return}
        let succeed = Player.sharedInstance.play(url: url)
        
        if succeed == true {
            print("Melodia \(name) este redata cu succes")
        } else {
            print("Melodia \(name) nu poate fi redata")
        }
    }
}
