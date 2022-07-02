//
//  ChooseSubjectUICollectionViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/25.
//

import UIKit
import AVFoundation

class ChooseSubjectUICollectionViewCell: UICollectionViewCell {
	
	static let reuseIdentifier = "\(ChooseSubjectUICollectionViewCell.self)"
	
	// MARK: - Properties
	
	let subjectImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = .orange10
		imageView.layer.cornerRadius = 12
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	var avPlayerLayer: AVPlayerLayer?
	
	var videoURL: URL? {
		didSet {
			setupAV()
		}
	}

	// MARK: - Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - UI
	
	func setupUI() {
		contentView.addSubview(subjectImageView)
		subjectImageView.addConstraintsToFillView(contentView)
	}
	
	// MARK: - Actions
	
	// MARK: - Helpers
	
	func setupAV() {
		guard let url = videoURL else { return }
		
		var avPlayer = AVPlayer()
		avPlayer = AVPlayer(url: url)
		avPlayerLayer = AVPlayerLayer(player: avPlayer)
		avPlayerLayer?.videoGravity = .resizeAspectFill
		avPlayerLayer?.player?.actionAtItemEnd = .none
		
		if let avPlayerLayer = avPlayerLayer {
			subjectImageView.layer.addSublayer(avPlayerLayer)
			avPlayerLayer.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
			avPlayer.play()
		}
	}
    
}
