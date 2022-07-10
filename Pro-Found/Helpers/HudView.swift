//
//  HudView.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/25.
//

import UIKit
import Lottie

class HudView: UIView {
	
	var text = "Success"
	let loadingImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage.asset(.spinning)
		imageView.setDimensions(width: 40, height: 40)
		return imageView
	}()
	
	static func hud(inView view: UIView, animated: Bool) -> HudView {
		let hudView = HudView(frame: view.bounds)
		hudView.isOpaque = false
		view.addSubview(hudView)
		view.isUserInteractionEnabled = false
		
		hudView.show(animated: true)
		return hudView
	}
	
	override func draw(_ rect: CGRect) {
		let boxWidth: CGFloat = 96
		let boxHeight: CGFloat = 96
		
		let boxRect = CGRect(x: round((bounds.size.width - boxWidth) / 2), y: round((bounds.size.height - boxHeight) / 2), width: boxWidth, height: boxHeight)
		let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
		UIColor(white: 0.3, alpha: 0.8).setFill()
		roundedRect.fill()
		// Draw image
		guard let image = UIImage.asset(.checkmarkHUD) else { return }
		let imagePoint = CGPoint(
			x: center.x - round(image.size.width / 2),
			y: center.y - round(image.size.height / 2) - boxHeight / 8)
		image.draw(at: imagePoint)
//		 Draw the text
		let attribs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
					   NSAttributedString.Key.foregroundColor: UIColor.light60
		]
		let textSize = text.size(withAttributes: attribs)
		let textPoint = CGPoint(x: center.x - round(textSize.width / 2), y: center.y - round(textSize.height / 2) + boxHeight / 4)
		text.draw(at: textPoint, withAttributes: attribs)
	}
	
	func load(animated: Bool, hud: UIView) {
		hud.addSubview(loadingImageView)
		loadingImageView.center(inView: hud)
		
		if animated {
			alpha = 0
			transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
			UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7,
						   initialSpringVelocity: 0.5, options: [], animations: {
					self.alpha = 1
					self.transform = CGAffineTransform.identity
				}, completion: nil)
		}
	}
	
	func show(animated: Bool) {
		if animated {
			alpha = 0
			transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
			UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7,
						   initialSpringVelocity: 0.5, options: [], animations: {
					self.alpha = 1
					self.transform = CGAffineTransform.identity
				}, completion: nil)
		}
	}
	
	func hide() {
		superview?.isUserInteractionEnabled = true
		UIView.animate(withDuration: 0.3) {
			self.alpha = 0
		} completion: { done in
			if done {
				self.removeFromSuperview()
			}
		}
	}
	
}
