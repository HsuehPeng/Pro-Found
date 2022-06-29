//
//  Lottie.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/29.
//

import Foundation
import Lottie
 
class Lottie {
	
	let animationView: AnimationView
	let superView: UIView
	
	init(superView: UIView, animationView: AnimationView) {
		self.superView = superView
		self.animationView = animationView
	}
	
	func loadingAnimation() {
		superView.addSubview(animationView)
		animationView.center(inView: superView)
		animationView.setDimensions(width: 150, height: 150)
		animationView.loopMode = .loop
		animationView.play()
	}
	
	func stopAnimation() {
		animationView.stop()
		animationView.removeFromSuperview()
	}
}
