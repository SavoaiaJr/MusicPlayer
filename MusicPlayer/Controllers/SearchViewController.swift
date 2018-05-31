//
//  SearchViewController.swift
//  MusicPlayer
//
//  Created by Madalin Savoaia on 5/19/18.
//  Copyright © 2018 Madalin Savoaia. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation

class SearchViewController: UIViewController {

    @IBOutlet weak var layerView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var songNameLabel: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var results: [YoutubeVideo] = []
    
    var webView: UIWebView?
    
    var currentYoutubeVideo: YoutubeVideo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func performDownload(youtubeVideo: YoutubeVideo) {
        if webView == nil {
            let frame = CGRect(x: 0, y: 60, width: view.frame.width, height: view.frame.height - 60)
            webView = UIWebView(frame: frame)
            view.addSubview(webView!)
            webView!.delegate = self
        }
        guard let webViewWrapped = webView else {return}
        guard let url = URL(string: "https://youtube7.download/mini.php?id=" + youtubeVideo.videoId) else {return}
        let urlRequest = URLRequest(url: url)
        webViewWrapped.loadRequest(urlRequest)
        webViewWrapped.isHidden = false
        currentYoutubeVideo = youtubeVideo
    }
    
    func downloadAndSaveMp3Song(url: URL) {
        layerView.isHidden = false
        activityIndicator.startAnimating()
        URLSession(configuration: .default).dataTask(with: url, completionHandler: { [weak self] (data, urlResponse, error) in
            guard let weakSelf = self else {return}
            guard let mp3Data = data else {return}
            
            guard let youtubeVideo = weakSelf.currentYoutubeVideo else {return}
            let succeed = SongsManager.sharedInstance.saveSong(data: mp3Data, youtubeVideo: youtubeVideo)
            
            if succeed == true {
                print("The song downloading and saving succeed.")
                DispatchQueue.main.async {
                    self?.layerView.isHidden = true                    
                }
            } else {
                print("The song downloading and saving was failed.")
            }
            
        }).resume()
    }
    
    
    @IBAction func searchAction(_ sender: Any) {
        songNameLabel.endEditing(true)
        guard let songName = songNameLabel.text else {return}
        RequestManager.sharedInstance.getVideosList(title: songName) { [weak self] videos in
            self?.results.removeAll()
            self?.results.append(contentsOf: videos)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let youtubeVideo = results[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = youtubeVideo.name
        guard let imageUrl = URL(string: youtubeVideo.thumbnailLink) else {return UITableViewCell()}
        do {
            let imageData = try Data(contentsOf: imageUrl)
            cell.imageView?.image = UIImage(data: imageData)
        } catch {
            print("\(error)")
        }
        cell.detailTextLabel?.text = youtubeVideo.descript
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let youtubeVideo = results[indexPath.row]
        performDownload(youtubeVideo: youtubeVideo)
    }
}

extension SearchViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        switch navigationType {
        case .linkClicked:
            guard let url = request.mainDocumentURL else {return true}
            downloadAndSaveMp3Song(url: url)
            print(url)
            webView.isHidden = true
            return false
        default:
            return true
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchAction(self)
        return true
    }
}
