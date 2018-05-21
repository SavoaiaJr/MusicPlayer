//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Madalin Savoaia on 5/18/18.
//  Copyright © 2018 Madalin Savoaia. All rights reserved.
//

import UIKit
import WebKit
class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let urlRequest = URLRequest(url: URL(string: "https://youtube7.download/mini.php?id=GTJHrHHAElU")!)
//        webView.loadRequest(urlRequest)

        
        RequestManager.sharedInstance.getVideosList(title: "NicolaeGuta") { results in
            print(results.description)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
//        webView.stringByEvaluatingJavaScript(from: "DownloadVideo()")
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        switch navigationType {
        case .linkClicked:
            let url = request.mainDocumentURL
            print(url)
            return false
        default:
            return true
        }
    }
}

