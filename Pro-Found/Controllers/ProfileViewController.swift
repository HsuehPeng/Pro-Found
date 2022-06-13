//
//  ProfileViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/13.
//

import UIKit

class ProfileViewController: UIViewController {

	// MARK: - Properties
	
	private let imageView: UIImageView = {
		let iv = UIImageView()
		iv.contentMode = .scaleAspectFill
		iv.backgroundColor = .red
		iv.translatesAutoresizingMaskIntoConstraints = false
		return iv
	}()
	
	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		print(view.frame.height)
		setupUI()
	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(imageView)
		imageView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 812 * (280 / 812))
	}
	
	// MARK: - Actions
	
	// MARK: - Helpers

}
