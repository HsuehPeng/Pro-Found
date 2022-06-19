//
//  ProfileViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/17.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

	// MARK: - Properties
	
	private lazy var logoutButton: UIButton = {
		let button = CustomUIElements().makeSmallButton(buttonColor: .orange, buttonTextColor: .white, borderColor: .clear, buttonText: "Log out")
		button.widthAnchor.constraint(equalToConstant: 60).isActive = true
		button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
		return button
	}()
	
	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		
		setupNavBar()
		setupUI()
		
	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(logoutButton)
		logoutButton.center(inView: view)
	}
	
	func setupNavBar() {
		navigationController?.navigationBar.isHidden = true
	}
	
	// MARK: - Actions
	
	@objc func handleLogout() {
		do {
			try Auth.auth().signOut()
		} catch let signOutError as NSError {
			print("Error signing out: %@", signOutError)
		}
		
		guard let window = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).flatMap({ $0.windows }).first(where: { $0.isKeyWindow }) else { return }
		
		guard let tab = window.rootViewController as? MainTabController else { return }
		
		tab.authenticateUserAndConfigureUI()
		self.dismiss(animated: true, completion: nil)
	}
	
	// MARK: - Helpers
	
	

}
