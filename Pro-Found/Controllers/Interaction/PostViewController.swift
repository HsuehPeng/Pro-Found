//
//  PostViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/19.
//

import UIKit

class PostViewController: UIViewController {
	
	// MARK: - Properties
	
	var user: User? {
		didSet {
			guard let user = user else { return }
			if user.isTutor {
				writePostButton.isHidden = false
			} else {
				writePostButton.isHidden = true
			}
		}
	}
	
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
	
	private lazy var writePostButton: UIButton = {
		let button = UIButton()
		let image = UIImage.asset(.edit)?.withTintColor(UIColor.orange)
		button.setImage(image, for: .normal)
		button.setDimensions(width: 54, height: 54)
		button.isHidden = true
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
		tableView.dataSource = self
		tableView.delegate = self
		
		setupUI()
    }
	
	// MARK: - UI
	
	private func setupUI() {
		view.addSubview(tableView)
		tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,
						 right: view.rightAnchor)
		
		view.addSubview(writePostButton)
		writePostButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 24, paddingRight: 16)
	}
	
	// MARK: - Actions
	
	@objc func handleWritePost() {
		guard let user = user else { return }
		let writePostVC = WritePostViewController(user: user)
		writePostVC.modalPresentationStyle = .fullScreen
		present(writePostVC, animated: true)
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
				feedCell.delegate = self
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

// MARK: - PostPageFeedCellDelegate

extension PostViewController: PostPageFeedCellDelegate {
	func goToCommentVC(_ cell: PostPageFeedCell) {
		guard let indexPath = tableView.indexPath(for: cell), let user = user else { return }
		let post = filteredPosts[indexPath.row]
		let postCommentVC = PostCommentViewController(post: post, user: user)
		navigationController?.pushViewController(postCommentVC, animated: true)
	}

}


