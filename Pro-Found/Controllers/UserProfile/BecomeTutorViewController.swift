//
//  File.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/23.
//

import Foundation
import UIKit

class BecomeTutorViewController: UIViewController {
	
	// MARK: - Properties
	 
	private lazy var languageButton: UIButton = {
		let button = makeButton(subjectTitle: "Language")
		return button
	}()
	
	private lazy var techButton: UIButton = {
		let button = makeButton(subjectTitle: "Technology")
		return button
	}()
	
	private lazy var sportButton: UIButton = {
		let button = makeButton(subjectTitle: "Sport")
		return button
	}()
	
	private lazy var artButton: UIButton = {
		let button = makeButton(subjectTitle: "Art")
		return button
	}()
	
	private lazy var musicButton: UIButton = {
		let button = makeButton(subjectTitle: "Music")
		return button
	}()
	
	private lazy var cancelButton: UIButton = {
		let button = UIButton()
		return button
	}()
		
	// MARK: - Lifecucle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	// MARK: - UI
	
	func setupUI() {
		
	}
	
	// MARK: - Actions
	
	@objc func subjectButtonPressed() {
		
	}
	
	// MARK: - Helpers
	
	func makeButton(subjectTitle: String) -> UIButton {
		let button = UIButton()
		button.setTitle(subjectTitle, for: .normal)
		button.setTitleColor(UIColor.dark40, for: .normal)
		button.setTitleColor(UIColor.light60, for: .selected)
		button.backgroundColor = .light60
		button.addTarget(self, action: #selector(subjectButtonPressed), for: .touchUpInside)
		return button
	}
	
}
