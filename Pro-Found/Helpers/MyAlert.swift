//
//  File.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/23.
//

import Foundation
import UIKit

class MyAlert {
	
	struct Constants {
		static let backgroundAplphaTo: CGFloat = 0.6
	}
	
	private let backgroundView: UIView = {
		let backgroundView = UIView()
		backgroundView.backgroundColor = .black
		backgroundView.alpha = 0
		return backgroundView
	}()
	
	private let alerView: UIView = {
		let alert = UIView()
		alert.backgroundColor = .white
		alert.layer.masksToBounds = true
		alert.layer.cornerRadius = 12
		return alert
	}()
	
	private var mytargetView: UIView?
	
	func showAlert(with title: String, message: String, on viewController: UIViewController) {
		guard let targetView = viewController.view else { return }
		mytargetView = targetView
		
		backgroundView.frame = targetView.bounds
		targetView.addSubview(backgroundView)
		targetView.addSubview(alerView)
		alerView.frame = CGRect(x: 40, y: -300, width: targetView.frame.size.width - 80, height: 300)
		
		let titleLabel = UILabel()
		alerView.addSubview(titleLabel)
		titleLabel.centerX(inView: alerView, topAnchor: alerView.topAnchor, paddingTop: 16)
		titleLabel.text = title
		titleLabel.textAlignment = .center
		
		let cancelButton = UIButton()
		cancelButton.setImage(UIImage.asset(.close), for: .normal)
		alerView.addSubview(cancelButton)
		cancelButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
		cancelButton.anchor(top: alerView.topAnchor, right: alerView.rightAnchor, paddingTop: 16, paddingRight: 16)
		
		let languageButton = UIButton()
		languageButton.setTitle("Language", for: .normal)
		languageButton.setTitleColor(.light60, for: .normal)
		languageButton.backgroundColor = .red
		
		let techButton = UIButton()
		techButton.setTitle("Technology", for: .normal)
		techButton.setTitleColor(.light60, for: .normal)
		techButton.backgroundColor = .red
		
		let sportButton = UIButton()
		sportButton.setTitle("Sport", for: .normal)
		sportButton.setTitleColor(.light60, for: .normal)
		sportButton.backgroundColor = .red
		
		let artButton = UIButton()
		artButton.setTitle("Art", for: .normal)
		artButton.setTitleColor(.light60, for: .normal)
		artButton.backgroundColor = .red
		
		let musicButton = UIButton()
		musicButton.setTitle("Music", for: .normal)
		musicButton.setTitleColor(.light60, for: .normal)
		musicButton.backgroundColor = .red
		
		let buttonHStack = UIStackView(arrangedSubviews: [languageButton, techButton, sportButton, artButton, musicButton])
		buttonHStack.spacing = 8
		alerView.addSubview(buttonHStack)
		buttonHStack.center(inView: alerView)
		
		let button = UIButton(frame: CGRect(x: 0, y: alerView.frame.size.height - 50, width: alerView.frame.size.width, height: 50))
		button.setTitle("Done", for: .normal)
		button.setTitleColor(.red, for: .normal)
		button.addTarget(self, action: #selector(finishBecomeTutor), for: .touchUpInside)
		alerView.addSubview(button)
		
		UIView.animate(withDuration: 0.2) {
			self.backgroundView.alpha = Constants.backgroundAplphaTo
		} completion: { done in
			if done {
				UIView.animate(withDuration: 0.25) {
					self.alerView.center = targetView.center
				}
			}
		}
	}
	
	@objc func dismissAlert() {
		guard let mytargetView = mytargetView else {
			return
		}
		UIView.animate(withDuration: 0.2) {
			self.alerView.frame = CGRect(x: 40, y: mytargetView.frame.size.height,
										 width: mytargetView.frame.size.width - 80, height: 300)
		} completion: { done in
			if done {
				UIView.animate(withDuration: 0.25) {
					self.backgroundView.alpha = 0
				} completion: { done in
					if done {
						self.alerView.removeFromSuperview()
						self.backgroundView.removeFromSuperview()
					}
				}
			}
		}
	}
	
	@objc func finishBecomeTutor() {
		guard let mytargetView = mytargetView else {
			return
		}
		
		UIView.animate(withDuration: 0.2) {
			self.alerView.frame = CGRect(x: 40, y: mytargetView.frame.size.height,
										 width: mytargetView.frame.size.width - 80, height: 300)
		} completion: { done in
			if done {
				UIView.animate(withDuration: 0.25) {
					self.backgroundView.alpha = 0
				} completion: { done in
					if done {
						self.alerView.removeFromSuperview()
						self.backgroundView.removeFromSuperview()
					}
				}
			}
		}
	}
	
}
