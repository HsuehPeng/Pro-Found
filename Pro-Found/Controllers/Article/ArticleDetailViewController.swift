//
//  ArticleDetailViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/18.
//

import UIKit

class ArticleDetailViewController: UIViewController {
	
	// MARK: - Properties
	
	let article: Article
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(ArticleDetailIntroTableViewCell.self, forCellReuseIdentifier: ArticleDetailIntroTableViewCell.reuseIdentifier)
		tableView.register(ArticleDetailContentTableViewCell.self, forCellReuseIdentifier: ArticleDetailContentTableViewCell.reuseIdentifier)
		tableView.separatorStyle = .none
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
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftBarItemImage, style: .done, target: self, action: #selector(popVC))
	}
	
	// MARK: - Actions
	
	@objc func popVC() {
		navigationController?.popViewController(animated: true)
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
		contentCell.article = article
		
		if indexPath.section == 0 {
			return introCell
		} else {
			return contentCell
		}
	}
}
