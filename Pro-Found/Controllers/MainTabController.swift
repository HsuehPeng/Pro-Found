//
//  ViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/10.
//

import UIKit
import FirebaseAuth

class MainTabController: UITabBarController {
	
	// MARK: - Properties
	
	var user: User? {
		didSet {
			guard let homeNav = viewControllers?[0] as? UINavigationController else { return }
			guard let homevc = homeNav.viewControllers.first as? HomeViewController else { return }
			homevc.user = user
			
			
//			guard let user = user else { return }
//			UserServie.shared.getUserData(uid: user.userID) { result in
//				switch result {
//				case .success(let user):
//					print(user)
//				case .failure(let error):
//					print(error)
//				}
//			}
			
			
		}
	}
	
	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		authenticateUserAndConfigureUI()
				
	}
	
	// MARK: - UI
	
	// MARK: - Actions
	
	// MARK: - Helpers
	
	func fetchUser() {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		UserServie.shared.getUserData(uid: uid) { result in
			switch result {
			case .success(let user):
				self.user = user
			case .failure(let error):
				print("Error fetching user: \(error)")
			}
		}
	}
	
	func authenticateUserAndConfigureUI() {
		if Auth.auth().currentUser == nil {
			DispatchQueue.main.async {
				let nav = UINavigationController(rootViewController: LoginViewController())
				nav.modalPresentationStyle = .fullScreen
				self.present(nav, animated: true, completion: nil)
			}
		} else {
			configureViewControllers()
			fetchUser()
		}
	}
	
	func configureViewControllers() {
		let homeVC = HomeViewController()
		let homeNav = templateNavigationController(image: UIImage.asset(.home), rootVC: homeVC)
		
		let feedVC = InteractionViewController()
		let feedNav = templateNavigationController(image: UIImage.asset(.article), rootVC: feedVC)
		
		let articleVC = ArticleViewController()
		let articleNav = templateNavigationController(image: UIImage.asset(.layers), rootVC: articleVC)
		
		let scheduleVC = ScheduleViewController()
		let scheduleNav = templateNavigationController(image: UIImage.asset(.calendar_selected), rootVC: scheduleVC)
		
		let profileVC = ProfileViewController()
		let profileNav = templateNavigationController(image: UIImage.asset(.account_circle), rootVC: profileVC)
		
		viewControllers = [homeNav, feedNav, articleNav, scheduleNav, profileNav]
	}
	
	func templateNavigationController(image: UIImage?, rootVC: UIViewController) -> UINavigationController {
		let nav = UINavigationController(rootViewController: rootVC)
		let appearance = UINavigationBarAppearance()
		appearance.configureWithDefaultBackground()
//		appearance.backgroundColor = .white
		nav.navigationBar.standardAppearance = appearance
		nav.tabBarItem.image = image
		nav.tabBarItem.selectedImage = image?.withTintColor(UIColor.orange, renderingMode: .alwaysOriginal)
		return nav
	}
}
