//
//  PostViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/19.
//

import UIKit

class PostViewController: UIViewController {
	
	// MARK: - Properties
	
	var filteredPosts = [Post]() {
		didSet {
			tableView.reloadData()
		}
	}
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(PostPageFeedCell.self, forCellReuseIdentifier: PostPageFeedCell.reuseIdentifier)
		tableView.separatorStyle = .none
		return tableView
	}()
	
	// MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()		
		tableView.dataSource = self
		tableView.delegate = self
		
		setupUI()
    }
	
	// MARK: - UI
	
	private func setupUI() {
		view.addSubview(tableView)
		tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,
						 right: view.rightAnchor)
	}
	
}

// MARK: - UITableViewDataSource
 
extension PostViewController: UITableViewDataSource {
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

extension PostViewController: UITableViewDelegate {
	
}
