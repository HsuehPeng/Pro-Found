//
//  PostViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/19.
//

import Lottie
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
		tableView.register(PostPageVideoCell.self, forCellReuseIdentifier: PostPageVideoCell.reuserIdentifier)
		tableView.separatorStyle = .none
		
		return tableView
	}()
	
	private let emptyIndicatorView: UIView = {
		let view = UIView()
		view.backgroundColor = .light60
		
		return view
	}()
	
	private lazy var writePostButton: UIButton = {
		let button = UIButton()
		let image = UIImage.asset(.edit)?.withTintColor(UIColor.orange)
		button.setImage(image, for: .normal)
		button.setDimensions(width: 54, height: 54)
		button.isHidden = true
		button.layer.cornerRadius = 54 / 2
		button.backgroundColor = .light60
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
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		let cells = tableView.visibleCells
		cells.forEach { cell in
			guard let cell = cell as? PostPageVideoCell else { return }
			cell.looper = nil
			cell.avQueueplayer.pause()
			cell.avQueueplayer.removeAllItems()
		}
	}
	
	// MARK: - UI
	
	private func setupUI() {
		
		view.addSubview(tableView)
		tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
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
	
	// MARK: - Helper

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
				as? PostPageFeedCell else { fatalError("Can not dequeue PostPageFeedCell") }
		guard let videoFeedCell = tableView.dequeueReusableCell(withIdentifier: PostPageVideoCell.reuserIdentifier, for: indexPath)
				as? PostPageVideoCell else { fatalError("Can not dequeue PostPageVideoCell") }
		
		let post = filteredPosts[indexPath.row]
		
		if post.videoURL?.count ?? 0 > 0 {
			videoFeedCell.delegate = self
			videoFeedCell.user = user
			videoFeedCell.post = post
			videoFeedCell.selectionStyle = .none
			return videoFeedCell
		} else {
			feedCell.delegate = self
			feedCell.user = user
			feedCell.post = post
			feedCell.selectionStyle = .none
			return feedCell
		}
	}
}

// MARK: - UITableViewDelegate

extension PostViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if let cell = cell as? PostPageVideoCell {
			cell.avQueueplayer.pause()
			cell.avQueueplayer.removeAllItems()
			cell.looper = nil
		}
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if let cell = cell as? PostPageVideoCell {
			cell.setupAvPlayer()
		}
	}
}

// MARK: - PostPageFeedCellDelegate

extension PostViewController: PostPageFeedCellDelegate {
	
	func checkIfLikedByUser(_ cell: PostPageFeedCell) {
		guard let post = cell.post, let user = user else { return }
		
		if post.likedBy.contains(user.userID) {
			cell.likeButton.isSelected = true
		} else {
			cell.likeButton.isSelected = false
		}
	}
	
	func likePost(_ cell: PostPageFeedCell) {
		guard let post = cell.post, let user = user else { return }
		
		guard let indexPath = tableView.indexPath(for: cell) else { return }
		
		if cell.likeButton.isSelected {
			PostService.shared.unlikePost(post: post, userID: user.userID) { 
				
			}
			cell.post?.likes -= 1
			cell.likeButton.isSelected = false
		} else {
			PostService.shared.likePost(post: post, userID: user.userID) {
				
			}
			cell.post?.likes += 1
			cell.likeButton.isSelected = true
		}
	}
	
	func goToCommentVC(_ cell: PostPageFeedCell) {
		guard let indexPath = tableView.indexPath(for: cell), let user = user else { return }
		let post = filteredPosts[indexPath.row]
		let postCommentVC = PostCommentViewController(post: post, user: user)
		navigationController?.pushViewController(postCommentVC, animated: true)
	}
	
	func goToPostUserProfile(_ cell: PostPageFeedCell) {
		guard let post = cell.post, let user = user else { return }
		let publicProfilePage = TutorProfileViewController(user: user, tutor: post.user)
		navigationController?.pushViewController(publicProfilePage, animated: true)
	}
	
	func askToDelete(_ cell: PostPageFeedCell) {
		guard let post = cell.post, let indexPath = tableView.indexPath(for: cell), let user = user else { return }
		
		let loadingLottie = Lottie(superView: view, animationView: AnimationView.init(name: "loadingAnimation"))
		
		let controller = UIAlertController(title: "Are you sure to delete this post?", message: nil, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Sure", style: .destructive) { _ in
			loadingLottie.loadingAnimation()
			PostService.shared.deletePost(postID: post.postID, userID: user.userID) { [weak self] in
				guard let self = self else { return }
				self.filteredPosts.remove(at: indexPath.row)
				loadingLottie.stopAnimation()
			}
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		controller.addAction(okAction)
		controller.addAction(cancelAction)
		
		present(controller, animated: true, completion: nil)
	}
}

extension PostViewController: PostPageVideoCellDelegate {
	
	func toggleVideoVolunm(_ cell: PostPageVideoCell) {
		if cell.isVolumnOn {
			cell.avQueueplayer.volume = 1
		} else {
			cell.avQueueplayer.volume = 0
		}
	}
	
	func goToPostUserProfile(_ cell: PostPageVideoCell) {
		guard let post = cell.post, let user = user else { return }
		let publicProfilePage = TutorProfileViewController(user: user, tutor: post.user)
		navigationController?.pushViewController(publicProfilePage, animated: true)
	}
	
	func goToCommentVC(_ cell: PostPageVideoCell) {
		guard let indexPath = tableView.indexPath(for: cell), let user = user else { return }
		let post = filteredPosts[indexPath.row]
		let postCommentVC = PostCommentViewController(post: post, user: user)
		navigationController?.pushViewController(postCommentVC, animated: true)
	}
	
	func likePost(_ cell: PostPageVideoCell) {
		guard let post = cell.post, let user = user else { return }
		
		if cell.likeButton.isSelected {
			PostService.shared.unlikePost(post: post, userID: user.userID) {
				
			}
			cell.post?.likes -= 1
			cell.likeButton.isSelected = false
		} else {
			PostService.shared.likePost(post: post, userID: user.userID) {
				
			}
			cell.post?.likes += 1
			cell.likeButton.isSelected = true
		}
	}
	
	func checkIfLikedByUser(_ cell: PostPageVideoCell) {
		guard let post = cell.post, let user = user else { return }
		if post.likedBy.contains(user.userID) {
			cell.likeButton.isSelected = true
		} else {
			cell.likeButton.isSelected = false
		}
	}
	
	func askToDelete(_ cell: PostPageVideoCell) {
		guard let post = cell.post, let indexPath = tableView.indexPath(for: cell), let user = user else { return }
		
		let loadingLottie = Lottie(superView: view, animationView: AnimationView.init(name: "loadingAnimation"))
		
		let controller = UIAlertController(title: "Are you sure to delete this post?", message: nil, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Sure", style: .destructive) { _ in
			loadingLottie.loadingAnimation()
			PostService.shared.deletePost(postID: post.postID, userID: user.userID) { [weak self] in
				guard let self = self else { return }
				self.filteredPosts.remove(at: indexPath.row)
				loadingLottie.stopAnimation()
			}
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		controller.addAction(okAction)
		controller.addAction(cancelAction)
		
		present(controller, animated: true, completion: nil)
	}
	
}
