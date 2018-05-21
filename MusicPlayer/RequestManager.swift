//
//  RequestManager.swift
//  MusicPlayer
//
//  Created by Madalin Savoaia on 5/18/18.
//  Copyright © 2018 Madalin Savoaia. All rights reserved.
//

import UIKit

class RequestManager: NSObject {
    static let sharedInstance = RequestManager()
    
    func getVideosList(title: String, completion: @escaping (_ results: [YoutubeVideo]) -> Void) {
        
        guard let titleEscaped = title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        let urlPath = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&q=" + titleEscaped + "&key=AIzaSyCZxo1eYvqwXe96D-x2PnmJON_tIIl34mk";
        guard let url = URL(string: urlPath) else {return}
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let dataWrapped = data else {return}

            do {
                let json = try JSONSerialization.jsonObject(with: dataWrapped, options: .mutableLeaves)
                guard let dict = json as? Dictionary<String, Any> else {return}
                guard let videos = dict["items"] as? Array<Any> else {return}
                var results: Array<YoutubeVideo> = Array()
                for index in 0...videos.count-1 {
                    guard let video = videos[index] as? Dictionary<String, Any> else {break}
                    guard let snippet = video["snippet"] as? Dictionary<String, Any> else {break}
                    guard let name = snippet["title"] as? String else {break}
                    guard let thumbnails = snippet["thumbnails"] as? Dictionary<String, Dictionary<String, Any>> else {break}
                    guard let defaultThumbnail = thumbnails["default"] else {break}
                    guard let defaultThumbnailLink = defaultThumbnail["url"] as? String else {break}
                    guard let id = video["id"] as? Dictionary<String, String> else {break}
                    guard let videoId = id["videoId"] else {break}
                    guard let descript = snippet["description"] as? String else {break}
                    
                    print("name: \(name), description: \(descript), videoId: \(String(describing: videoId))", "thumbnailLink: \(String(describing: defaultThumbnailLink))")
                    results.append(YoutubeVideo(name: name, descript: descript, videoId: videoId, thumbnailLink: defaultThumbnailLink))
                
                }
                
                completion(results)
          
            }
            catch {
                print("json error:\(error)");
            }
        }.resume()
        
    }
}
