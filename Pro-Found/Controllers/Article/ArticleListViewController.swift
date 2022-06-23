//
//  ArticleListViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/23.
//

import UIKit

class ArticleListViewController: UIViewController {
	
	// MARK: - Properties
	
	let articles: [Article]
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(ArticleListTableViewCell.self, forCellReuseIdentifier: ArticleListTableViewCell.reuseIdentifier)
		return tableView
	}()
	
	// MARK: - Lifecycle
	
	init(articles: [Article]) {
		self.articles = articles
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .light60
		
		tableView.dataSource = self
		tableView.delegate = self
		
		setupUI()
		setupNavBar()
    }
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(tableView)
		tableView.addConstraintsToFillView(view)
	}
	
	func setupNavBar() {
		navigationController?.navigationBar.isHidden = false
		tabBarController?.tabBar.isHidden = true
		let leftBarItemImage = UIImage.asset(.chevron_left)?.withRenderingMode(.alwaysOriginal)
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftBarItemImage, style: .done,
														   target: self, action: #selector(popVC))
	}
	
	// MARK: - Actions
	
	@objc func popVC() {
		navigationController?.popViewController(animated: true)
	}
	
	// MARK: - Helpers
	
}

// MARK: - UITableViewDataSource

extension ArticleListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return articles.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleListTableViewCell.reuseIdentifier, for: indexPath)
				as? ArticleListTableViewCell else { fatalError("Can not dequeue ArticleListTableViewCell") }
		cell.article = articles[indexPath.row]
		return cell
	}
}

// MARK: - UITableViewDelegate

extension ArticleListViewController: UITableViewDelegate {
	
}
