//
//  MissingInputViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/28.
//

import UIKit

class MissingInputViewController: UIViewController {

	// MARK: - Properties
	
	private let middleView: UIView = {
		let view = UIView()
		view.backgroundColor = .light60
		view.alpha = 0.95
		view.layer.cornerRadius = 24
		view.setDimensions(width: 295, height: 256)
		return view
	}()
	
	private let decorateImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage.asset(.eco)
		imageView.setDimensions(width: 48, height: 48)
		return imageView
	}()
	
	private let loginLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 20),
												 textColor: .dark, text: "Missing Input")
		return label
	}()
	
	private let explainLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 14),
												 textColor: .dark40, text: "There is one or more required input missing")
		label.textAlignment = .center
		label.numberOfLines = 0
		return label
	}()
	
	private let dividerView: UIView = {
		let view = UIView()
		view.backgroundColor = .dark20
		return view
	}()
	
	private lazy var okButton: UIButton = {
		let button = UIButton()
		button.setTitle("Got it", for: .normal)
		button.setTitleColor(UIColor.orange, for: .normal)
		button.titleLabel?.font = UIFont.customFont(.interBold, size: 16)
		button.addTarget(self, action: #selector(handleDissmissVC), for: .touchUpInside)
		return button
	}()
	
	
	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .dark.withAlphaComponent(0.5)
		
		setupUI()
	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(middleView)
		middleView.center(inView: view)
		
		middleView.addSubview(decorateImageView)
		decorateImageView.centerX(inView: middleView, topAnchor: middleView.topAnchor, paddingTop: 30)
		
		middleView.addSubview(loginLabel)
		loginLabel.centerX(inView: middleView, topAnchor: decorateImageView.bottomAnchor, paddingTop: 24)
		
		middleView.addSubview(explainLabel)
		explainLabel.centerX(inView: middleView, topAnchor: loginLabel.bottomAnchor, paddingTop: 8)
		explainLabel.anchor(left: middleView.leftAnchor, right: middleView.rightAnchor, paddingLeft: 16, paddingRight: 16)
		
		middleView.addSubview(dividerView)
		dividerView.anchor(top: explainLabel.bottomAnchor, left: middleView.leftAnchor, right: middleView.rightAnchor,
						   paddingTop: 24, height: 1)
		
		middleView.addSubview(okButton)
		okButton.centerX(inView: middleView, topAnchor: dividerView.bottomAnchor, paddingTop: 12)
		
	}
	
	// MARK: - Actions
	
	@objc func handleDissmissVC() {
		dismiss(animated: true)
	}

}
