//
//  FeedViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/13.
//

import UIKit
import FirebaseAuth

class FeedViewController: UIViewController {

	// MARK: - Properties
	
	var user: User?
	
	var posts = [Post]()
	
	var filteredPosts = [Post]() {
		didSet {
			tableView.reloadData()
		}
	}
	
		
	private let topBarView: UIView = {
		let view = UIView()
		return view
	}()
	
	private let pageTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 24),
												 textColor: UIColor.dark60, text: "Posts")
		return label
	}()
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(PostPageFeedCell.self, forCellReuseIdentifier: PostPageFeedCell.reuseIdentifier)
		tableView.separatorStyle = .none
		return tableView
	}()
	
	private lazy var writePostButton: UIButton = {
		let button = UIButton()
		let image = UIImage.asset(.edit)?.withTintColor(UIColor.orange)
		button.setImage(image, for: .normal)
		button.setDimensions(width: 54, height: 54)
		button.layer.cornerRadius = 54 / 2
		button.backgroundColor = .white
		button.layer.shadowColor = UIColor.dark60.cgColor
		button.layer.shadowOffset = CGSize(width: 0, height: 4)
		button.layer.shadowRadius = 10
		button.layer.shadowOpacity = 0.3
		button.addTarget(self, action: #selector(handleWritePost), for: .touchUpInside)
		return button
	}()
	
	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		
		tableView.dataSource = self
		tableView.delegate = self
		
		setupNavBar()
		setupUI()
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		loadUserData()
	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(topBarView)
		topBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
						  right: view.rightAnchor, height: 48)
		
		topBarView.addSubview(pageTitleLabel)
		pageTitleLabel.centerY(inView: topBarView, leftAnchor: topBarView.leftAnchor, paddingLeft: 16)
		
		view.addSubview(tableView)
		tableView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
						 right: view.rightAnchor)
		
		view.addSubview(writePostButton)
		writePostButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 24, paddingRight: 16)
	}
	
	func setupNavBar() {
		navigationController?.navigationBar.isHidden = true
	}
	
	// MARK: - Actions
	
	@objc func handleWritePost() {
		guard let user = user else { return }
		let writePostVC = WritePostViewController(user: user)
		writePostVC.modalPresentationStyle = .fullScreen
		present(writePostVC, animated: true)
	}
	
	// MARK: - Helpers
	
	func loadUserData() {
		guard let uid = Auth.auth().currentUser?.uid  else { return }
		UserServie.shared.getUserData(uid: uid) { result in
			switch result {
			case .success(let user):
				self.user = user
				self.getPosts()
			case .failure(let error):
				print(error)
			}
		}
	}
	
	func getPosts() {
		guard let user = user else { return }
		PostService.shared.getPosts(user: user) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let posts):
				self.posts = posts
				self.filteredPosts = self.filterPosts()
			case .failure(let error):
				print(error)
			}
		}
	}
	
	func filterPosts() -> [Post] {
		guard let user = user else {
			return []
		}
		var filteredPosts = [Post]()
		for post in posts {
			if user.followings.contains(post.userID) {
				filteredPosts.append(post)
			}
		}
		return filteredPosts
	}

}

// MARK: - UITableViewDataSource
 
extension FeedViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filteredPosts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let feedCell = tableView.dequeueReusableCell(withIdentifier: PostPageFeedCell.reuseIdentifier, for: indexPath)
				as? PostPageFeedCell else { return UITableViewCell() }
		let post = filteredPosts[indexPath.row]
		UserServie.shared.getUserData(uid: post.userID) { result in
			switch result {
			case .success(let user):
				feedCell.user = user
			case .failure(let error):
				print(error)
			}
		}
		feedCell.post = post
		return feedCell
	}
}

// MARK: - UITableViewDelegate

extension FeedViewController: UITableViewDelegate {
	
}
