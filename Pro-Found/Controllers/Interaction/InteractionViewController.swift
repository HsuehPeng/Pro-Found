//
//  FeedViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/13.
//

import UIKit
import FirebaseAuth

class InteractionViewController: UIViewController {

	// MARK: - Properties
	
	var user: User? {
		didSet {
			postVC.user = user
			eventVC.user = user
		}
	}
	
	var posts = [Post]()
	
	var filteredPosts = [Post]() {
		didSet {
			postVC.filteredPosts = filteredPosts
		}
	}
	
	var events = [Event]() {
		didSet {
			eventVC.events = events
		}
	}
	
	let postVC = PostViewController()
	let eventVC = EventViewController()
	
	private let topBarView: UIView = {
		let view = UIView()
		return view
	}()
	
	private var pageTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 24),
												 textColor: UIColor.dark60, text: "Posts")
		return label
	}()
	
	private let optionBarView: UIView = {
		let view = UIView()
		return view
	}()
	
	private lazy var postOptionButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.asset(.intern), for: .normal)
		button.addTarget(self, action: #selector(handleOptionButton), for: .touchUpInside)
		return button
	}()
	
	private lazy var eventOptionButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.asset(.event), for: .normal)
		button.addTarget(self, action: #selector(handleOptionButton), for: .touchUpInside)
		return button
	}()
	
	private let indicatorView: UIView = {
		let view = UIView()
		view.backgroundColor = .dark40
		return view
	}()
	
	private let contaninerView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		return view
	}()
	
	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		
		setupNavBar()
		setupUI()
		setupChildVC()
	}
	
	func setupChildVC() {
		
		addChild(postVC)
		addChild(eventVC)
		contaninerView.addSubview(postVC.view)
		contaninerView.addSubview(eventVC.view)
		
		postVC.didMove(toParent: self)
		eventVC.didMove(toParent: self)
		
		postVC.view.frame = self.contaninerView.bounds
		eventVC.view.frame = self.contaninerView.bounds
		eventVC.view.isHidden = true
		
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
		
		view.addSubview(optionBarView)
		optionBarView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor,
						  right: view.rightAnchor, height: 48)
		
		optionBarView.addSubview(indicatorView)
		indicatorView.anchor(left: view.leftAnchor, bottom: optionBarView.bottomAnchor)
		indicatorView.setDimensions(width: view.frame.size.width / 2, height: 2)
		
		optionBarView.addSubview(postOptionButton)
		postOptionButton.anchor(top: optionBarView.topAnchor, left: view.leftAnchor, bottom: indicatorView.topAnchor)
		postOptionButton.widthAnchor.constraint(equalToConstant: view.frame.size.width / 2).isActive = true
		
		optionBarView.addSubview(eventOptionButton)
		eventOptionButton.anchor(top: optionBarView.topAnchor, bottom: indicatorView.topAnchor, right: view.rightAnchor)
		eventOptionButton.widthAnchor.constraint(equalToConstant: view.frame.size.width / 2).isActive = true
		
		view.addSubview(contaninerView)
		contaninerView.anchor(top: optionBarView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
	}
	
	func setupNavBar() {
		navigationController?.navigationBar.isHidden = true
	}
	
	// MARK: - Actions
	
	@objc func handleOptionButton(_ sender: UIButton) {
		pageTitleLabel.text = sender == postOptionButton ? "Posts" : "Events"
		
		if sender == postOptionButton {
			postOptionButton.isSelected = true
			eventOptionButton.isSelected = false
			self.postVC.view.isHidden = false
			self.eventVC.view.isHidden = true
			
			UIView.animate(withDuration: 0.5) {
				self.indicatorView.transform = CGAffineTransform(translationX: 0, y: 0)
				self.indicatorView.layoutIfNeeded()
			}
		} else {
			postOptionButton.isSelected = false
			eventOptionButton.isSelected = true
			self.postVC.view.isHidden = true
			self.eventVC.view.isHidden = false
			
			UIView.animate(withDuration: 0.3) {
				self.indicatorView.transform = CGAffineTransform(translationX: self.view.frame.width / 2, y: 0)
				self.indicatorView.layoutIfNeeded()
			}
		}
		
	}
	
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
				self.fetchPosts()
				self.fetchEvents()
			case .failure(let error):
				print(error)
			}
		}
	}
	
	func fetchPosts() {
		PostService.shared.getPosts { [weak self] result in
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
	
	func fetchEvents() {
		EventService.shared.fetchEvents { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let events):
				self.events = self.filterAndSortEvents(events: events)
			case .failure(let error):
				print(error)
			}
		}
	}
	
	func filterAndSortEvents(events: [Event]) -> [Event] {
		let date = Date()
		let currentTimeInterval = date.timeIntervalSince1970
		let filteredEvents = events.filter({ $0.timestamp > currentTimeInterval })
		let sortedFilteredEvents = filteredEvents.sorted(by: { $0.timestamp < $1.timestamp })
		
		return sortedFilteredEvents
	}

}
