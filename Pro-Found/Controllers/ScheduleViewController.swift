//
//  ScheduleViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/13.
//

import UIKit

class ScheduleViewController: UIViewController {

	// MARK: - Properties
	
	private let topBarView: UIView = {
		let view = UIView()
		return view
	}()
	
	private let pageTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 24),
												 textColor: UIColor.dark60, text: "Posts")
		return label
	}()
	
	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		
		setupUI()
	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(topBarView)
		topBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
						  right: view.rightAnchor, height: 48)
		
		topBarView.addSubview(pageTitleLabel)
		pageTitleLabel.centerY(inView: topBarView, leftAnchor: topBarView.leftAnchor, paddingLeft: 16)
		
	}
	
	// MARK: - Actions
	
	// MARK: - Helpers

}
