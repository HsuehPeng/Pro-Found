//
//  PostCommentViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/21.
//

import UIKit

class PostCommentViewController: UIViewController {
	
	// MARK: - Properties
	
	let user: User
	
	let post: Post
	
	var replies = [Reply]() {
		didSet {
			tableView.reloadData()
		}
	}
	
//	var replyUsers = [User]()
	
	private let tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped)
		tableView.backgroundColor = .light60
		tableView.register(PostCommentTableHeader.self, forHeaderFooterViewReuseIdentifier: PostCommentTableHeader.reuserIdentifier)
		tableView.register(PostCommentTableCellTableViewCell.self,
						   forCellReuseIdentifier: PostCommentTableCellTableViewCell.reuseIdentifier)
		tableView.separatorStyle = .none
		return tableView
	}()
	
	private let bottomBarView: UIView = {
		let view = UIView()
		view.backgroundColor = .light60
		return view
	}()
	
	private let commenterImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.setDimensions(width: 32, height: 32)
		imageView.layer.cornerRadius = 32 / 2
		imageView.backgroundColor = .dark20
		return imageView
	}()
	
	private lazy var commentTextView: CaptionTextView = {
		let textView = CaptionTextView()
//		textView.isScrollEnabled = false
		textView.layer.cornerRadius = 12
		return textView
	}()
	
	private lazy var sendCommentButton: UIButton = {
		let button = UIButton()
		let image = UIImage.asset(.send)?.withRenderingMode(.alwaysOriginal)
		button.setImage(image, for: .normal)
		button.addTarget(self, action: #selector(sendReply), for: .touchUpInside)
		button.setDimensions(width: 32, height: 32)
		return button
	}()
	
	// MARK: - Lifecycle
	
	init(post: Post, user: User) {
		self.post = post
		self.user = user
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Comment"
		view.backgroundColor = .light60
		
		tableView.dataSource = self
		tableView.delegate = self
		
		setupNavBar()
		setupUI()
		fetchReplies()

	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(tableView)
		tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
		
		view.addSubview(bottomBarView)
		bottomBarView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.4).isActive = true
		bottomBarView.anchor(top: tableView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,
							 right: view.rightAnchor, paddingBottom: 16)
		
		bottomBarView.addSubview(commenterImageView)
		commenterImageView.anchor(top: bottomBarView.topAnchor, left: bottomBarView.leftAnchor, paddingTop: 14, paddingLeft: 16)
		
		bottomBarView.addSubview(commentTextView)
		commentTextView.anchor(top: bottomBarView.topAnchor, left: commenterImageView.rightAnchor,
							   bottom: bottomBarView.bottomAnchor, paddingTop: 14, paddingLeft: 16, paddingBottom: 14)
		
		bottomBarView.addSubview(sendCommentButton)
		sendCommentButton.anchor(top: bottomBarView.topAnchor, left: commentTextView.rightAnchor,
								 right: bottomBarView.rightAnchor, paddingTop: 14, paddingLeft: 8, paddingRight: 16)
	}
	
	func setupNavBar() {
		navigationController?.navigationBar.isHidden = false
		tabBarController?.tabBar.isHidden = true

		let leftImage = UIImage.asset(.chevron_left)?.withRenderingMode(.alwaysOriginal)
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftImage, style: .done,
														   target: self, action: #selector(popVC))

	}
	
	// MARK: - Actions
	
	@objc func popVC() {
		navigationController?.popViewController(animated: true)
	}
	
	@objc func sendReply() {
		guard let commentText = commentTextView.text, !commentText.isEmpty else { return }
		let interval = Date().timeIntervalSince1970
		let reply = FirebaseReply(userID: user.userID, postID: post.postID, contentText: commentText, timestamp: interval)
		PostService.shared.uploadComment(firebaseReply: reply) { [weak self] in
			guard let self = self else { return }
			self.commentTextView.text = ""
			self.tableView.reloadData()
		}
	}
	
	// MARK: - Helpers
	
	func fetchReplies() {
		
		PostService.shared.getReplies { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let replies):
				self.replies = self.filterReplies(replies: replies)
			case .failure(let error):
				print(error)
			}
		}
	}
	
	func filterReplies(replies: [Reply]) -> [Reply] {
		return replies.filter({ $0.postID == post.postID })
	}

}

// MARK: - UITableViewDataSource

extension PostCommentViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return replies.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCommentTableCellTableViewCell.reuseIdentifier, for: indexPath)
				as? PostCommentTableCellTableViewCell else { fatalError("Can not dequeue PostCommentTableCellTableViewCell") }
		cell.reply = replies[indexPath.row]
		return cell
	}
}

// MARK: - UITableViewDelegate

extension PostCommentViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: PostCommentTableHeader.reuserIdentifier)
				as? PostCommentTableHeader else { fatalError("Can not dequeue PostCommentTableHeader") }
		header.post = post
		return header
	}
//
//	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//		return 100
//	}
	
}
