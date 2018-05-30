//
//  SmartPlayerView.swift
//  MusicPlayer
//
//  Created by Madalin Savoaia on 29/05/2018.
//  Copyright © 2018 Madalin Savoaia. All rights reserved.
//

import UIKit

protocol SmartPlayerViewDelegate {
    func rewind()
    func play()
    func fastforward()
    func sliderValueChanged(value: Float)
}

class SmartPlayerView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    var delegate:SmartPlayerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(String(describing: SmartPlayerView.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    @IBAction func rewind(_ sender: Any) {
        delegate?.rewind()
    }
    @IBAction func play(_ sender: Any) {
        delegate?.play()
    }
    @IBAction func fastforward(_ sender: Any) {
        delegate?.fastforward()
    }
    @IBAction func sliderValueChanged(_ sender: Any) {
        delegate?.sliderValueChanged(value: slider.value)
    }
    
}
