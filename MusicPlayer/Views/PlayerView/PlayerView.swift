//
//  PlayerView.swift
//  MusicPlayer
//
//  Created by Madalin Savoaia on 21/05/2018.
//  Copyright © 2018 Madalin Savoaia. All rights reserved.
//

import UIKit

protocol PlayerViewDelegate {
    func rewindButtonTapped()
    func playButtonTapped()
    func fastForwardButtonTapped()
    func sliderPositionChanged(value: Float)
}

class PlayerView: UIView {
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    var delegate: PlayerViewDelegate?
    var view: PlayerView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if self.subviews.count == 0 {
            xibSetup()
        }
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view?.frame = bounds
        view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view ?? UIView())
    }
    
    func loadViewFromNib() -> PlayerView? {
        let bundle = Bundle.main
        let nib = UINib(nibName: String(describing: PlayerView.self), bundle: bundle)
        return nib.instantiate(withOwner: self).first as? PlayerView
    }
    
    func setUp(songName: String) {
        view?.songNameLabel.text = songName
    }
    
    func setCurrentTime(value: String) {
        view?.currentTime.text = value
    }
    
    func setTotalTime(value: String) {
        view?.totalTime.text = value
    }
    
    @IBAction func rewindAction(_ sender: Any) {
        delegate?.rewindButtonTapped()
    }
    
    @IBAction func playAction(_ sender: Any) {
        delegate?.playButtonTapped()
    }
    
    @IBAction func fastForwardAction(_ sender: Any) {
        delegate?.fastForwardButtonTapped()
    }
    @IBAction func changeSliderPosition(_ sender: Any) {
        if let slider = sender as? UISlider {
            delegate?.sliderPositionChanged(value: slider.value)
        }
    }
}
