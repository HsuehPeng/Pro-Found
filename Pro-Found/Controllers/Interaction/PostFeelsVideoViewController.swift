//
//  PostVideoViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/7/14.
//

import UIKit
import AVFoundation
import Kingfisher
import MarqueeLabel

class PostFeelsVideoViewController: UIViewController {
	
	// MARK: - Properties
	
	var post: Post
	
	var avPlayerLayer = AVPlayerLayer()
	var avQueueplayer = AVQueuePlayer()
	var looper: AVPlayerLooper?
	
	private let videoLayerView: UIView = {
		let view = UIView()
		return view
	}()
	
	private let topbarView: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		return view
	}()
	
	private lazy var dismissButton: UIButton = {
		let button = UIButton()
		let image = UIImage.asset(.chevron_left)?.withRenderingMode(.alwaysOriginal).withTintColor(.light60)
		button.setImage(image, for: .normal)
		button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
		return button
	}()
	
	private let titleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 16),
												 textColor: .light60, text: "Feels")
		return label
	}()

	private let profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.setDimensions(width: 36, height: 36)
		imageView.layer.cornerRadius = 18
		imageView.backgroundColor = .light60
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		return imageView
	}()
	
	private let postUserNameLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 14),
												 textColor: .light60, text: "")
		
		return label
	}()
	
	private let postContentLabel: MarqueeLabel = {
		let label = MarqueeLabel()
		label.fadeLength = 10
		label.numberOfLines = 1
		label.font = UIFont.customFont(.manropeRegular, size: 16)
		label.textColor = .light60
		label.speed = .rate(20)
		return label
	}()
	
	// MARK: - Lifecycle
	
	init(post: Post) {
		self.post = post
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupUI()
		configureUI()
		setupAVPlayer()
    }
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(videoLayerView)
		view.addSubview(topbarView)
		topbarView.addSubview(dismissButton)
		topbarView.addSubview(titleLabel)
		view.addSubview(profileImageView)
		view.addSubview(postUserNameLabel)
		view.addSubview(postContentLabel)
		
		videoLayerView.addConstraintsToFillView(view)
		
		topbarView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
						  right: view.rightAnchor, height: 48)
		
		dismissButton.centerY(inView: topbarView, leftAnchor: topbarView.leftAnchor, paddingLeft: 16)
		
		titleLabel.center(inView: topbarView)
		
		profileImageView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 20,
								paddingBottom: view.frame.size.height * 0.2)
		
		postUserNameLabel.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
		
		postContentLabel.anchor(top: profileImageView.bottomAnchor, left: profileImageView.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingRight: view.frame.size.width * 0.3)
		
	}
	
	// MARK: - Actions
	
	@objc func dismissVC() {
		dismiss(animated: true)
	}
	
	// MARK: - Helpers
	
	func setupAVPlayer() {
		guard let urlString = post.videoURL else { return }
		
		CacheManager.shared.getFileWith(stringUrl: urlString) { [weak self] result in
			guard let self = self else { return }
			
			switch result {
			case .success(let url):
				
				let item = AVPlayerItem(url: url)
				self.looper = AVPlayerLooper(player: self.avQueueplayer, templateItem: item)
				self.avPlayerLayer = AVPlayerLayer(player: self.avQueueplayer)
				self.avPlayerLayer.videoGravity = .resizeAspectFill
				self.avPlayerLayer.player?.actionAtItemEnd = .none
				
				self.videoLayerView.layer.addSublayer(self.avPlayerLayer)
				self.avPlayerLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width,
											 height: UIScreen.main.bounds.height)
//				self.avPlayerLayer.addSublayer(self.toggleVolumeButton.layer)
				self.avQueueplayer.volume = 0
				
				self.avQueueplayer.play()
				
			case .failure(let error):
				print(error)
			}
		}
	}
	
	func configureUI() {
		guard let profileImageUrl = URL(string: post.user.profileImageURL) else { return }
		profileImageView.kf.setImage(with: profileImageUrl)
		postUserNameLabel.text = post.user.name
		postContentLabel.text = post.contentText
	}
	
}
