//
//  ProfileViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/17.
//

import UIKit

class ProfileViewController: UIViewController {

	// MARK: - Properties
	
	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		
		setupNavBar()
		setupUI()
		
	}
	
	// MARK: - UI
	
	func setupUI() {

	}
	
	func setupNavBar() {
		navigationController?.navigationBar.isHidden = true
	}
	
	// MARK: - Actions
	
	// MARK: - Helpers

}




