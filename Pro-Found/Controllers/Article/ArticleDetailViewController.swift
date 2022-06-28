//
//  ArticleDetailViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/18.
//

import UIKit
import FirebaseAuth

class ArticleDetailViewController: UIViewController {
	
	// MARK: - Properties
	
	let article: Article
	
	var isBookMarked: Bool = false
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(ArticleDetailIntroTableViewCell.self, forCellReuseIdentifier: ArticleDetailIntroTableViewCell.reuseIdentifier)
		tableView.register(ArticleDetailContentTableViewCell.self, forCellReuseIdentifier: ArticleDetailContentTableViewCell.reuseIdentifier)
		tableView.separatorStyle = .none
		tableView.allowsSelection = false
		return tableView
	}()
	
	// MARK: - Lifecycle
	
	init(article: Article) {
		self.article = article
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white
		
		tableView.dataSource = self
		checkIfBookMarded()
		setupNavBar()
		setupUI()
    }
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(tableView)
		tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
	}
	
	func setupNavBar() {
		navigationController?.navigationBar.isHidden = false
		tabBarController?.tabBar.isHidden = true
		let leftBarItemImage = UIImage.asset(.chevron_left)?.withRenderingMode(.alwaysOriginal)
		let rightBarItemImage = UIImage.asset(.bookmark)?.withTintColor(.dark40)
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftBarItemImage, style: .done, target: self, action: #selector(popVC))
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarItemImage, style: .done, target: self, action: #selector(bookmarkArticle))
	}
	
	// MARK: - Actions
	
	@objc func bookmarkArticle() {
		guard let uid = Auth.auth().currentUser?.uid else {
			let popUpAskToLoginVC = PopUpAskToLoginController()
			popUpAskToLoginVC.modalTransitionStyle = .crossDissolve
			popUpAskToLoginVC.modalPresentationStyle = .overCurrentContext
			present(popUpAskToLoginVC, animated: true)
			
			return
		}
		
		if isBookMarked {
			ArticleService.shared.cancelFavoriteArticles(articleID: article.articleID, userID: uid) { [weak self] in
				guard let self = self else { return }
				self.navigationItem.rightBarButtonItem?.tintColor = UIColor.dark40
				self.isBookMarked = false
			}
		} else {
			ArticleService.shared.addFavoriteArticles(articleID: article.articleID, userID: uid) { [weak self] in
				guard let self = self else { return }
				self.navigationItem.rightBarButtonItem?.tintColor = UIColor.orange
				self.isBookMarked = true
			}
		}
	}
	
	@objc func popVC() {
		navigationController?.popViewController(animated: true)
	}
	
	// MARK: Helpers
	
	func checkIfBookMarded() {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		ArticleService.shared.checkIfBookMarked(articleID: article.articleID, userID: uid) { [weak self] isBookMarked in
			guard let self = self else { return }
			self.isBookMarked = isBookMarked
			if isBookMarked {
				self.navigationItem.rightBarButtonItem?.tintColor = .orange
			} else {
				self.navigationItem.rightBarButtonItem?.tintColor = .dark40
			}
		}
	}

}

// MARK: - UITableViewDataSource

extension ArticleDetailViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let introCell = tableView.dequeueReusableCell(withIdentifier: ArticleDetailIntroTableViewCell.reuseIdentifier, for: indexPath)
				as? ArticleDetailIntroTableViewCell else { fatalError("Can not dequeue ArticleDetailIntroTableViewCell") }
		guard let contentCell = tableView.dequeueReusableCell(withIdentifier: ArticleDetailContentTableViewCell.reuseIdentifier, for: indexPath)
				as? ArticleDetailContentTableViewCell else { fatalError("Can not dequeue ArticleDetailContentTableViewCell") }
		introCell.article = article
		introCell.delegate = self
		contentCell.article = article
		
		if indexPath.section == 0 {
			return introCell
		} else {
			return contentCell
		}
	}
}

extension ArticleDetailViewController: ArticleDetailIntroTableViewCellDelegate {
	func handleRateArticlePopUp(_ cell: ArticleDetailIntroTableViewCell) {
		
	}
	
	func handleSendRating(_ cell: ArticleDetailIntroTableViewCell) {
		guard Auth.auth().currentUser != nil else {
			let popUpAskToLoginVC = PopUpAskToLoginController()
			popUpAskToLoginVC.modalTransitionStyle = .crossDissolve
			popUpAskToLoginVC.modalPresentationStyle = .overCurrentContext
			present(popUpAskToLoginVC, animated: true)
			return
		}
		return
	}
	
	
}
