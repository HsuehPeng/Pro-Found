//
//  ViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/10.
//

import UIKit

class MainTabController: UITabBarController {
	
	// MARK: - Properties
	
	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		configureViewControllers()
		
	}
	
	// MARK: - UI
	
	// MARK: - Actions
	
	// MARK: - Helpers
	
	func configureViewControllers() {
		let homeVC = HomeViewController()
		let homeNav = templateNavigationController(image: UIImage.asset(.home), rootVC: homeVC)
		
		let feedVC = FeedViewController()
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
		appearance.backgroundColor = .white
		nav.navigationBar.standardAppearance = appearance
		nav.tabBarItem.image = image
		nav.tabBarItem.selectedImage = image?.withTintColor(UIColor.orange, renderingMode: .alwaysOriginal)
		return nav
	}
}
