//
//  EmptyIndicatorView.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/7/12.
//

import UIKit
import Lottie

class EmptyIndicatorView: UIView {

	// MARK: - Properties
	
	lazy var indicatorLottie: Lottie = {
		let lottie = Lottie(superView: self, animationView: AnimationView(name: "emptyAnimation"))
		return lottie
	}()
	
	let indicatorLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 20), textColor: .dark30, text: "")
		label.textAlignment = .center
		return label
	}()
	// MARK: - Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
		self.backgroundColor = .light60
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - UI
	
	func setupUI() {
		self.addSubview(indicatorLottie.animationView)
		self.addSubview(indicatorLabel)
		
		indicatorLottie.animationView.center(inView: self)
		
		indicatorLabel.centerX(inView: self, topAnchor: indicatorLottie.animationView.bottomAnchor, paddingTop: 8)
		indicatorLabel.anchor(left: self.leftAnchor, right: self.rightAnchor)
	}

}
