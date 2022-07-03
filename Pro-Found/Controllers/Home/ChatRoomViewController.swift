//
//  ChatRoomViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/30.
//

import UIKit
 
class ChatRoomViewController: UIViewController {
		
	// MARK: - Properties
	
	let searchController = UISearchController()
	
	let user: User
	
	var conversations = [Conversation]()
	
	var filteredConversations = [Conversation]()
	
	var isSearchBarEmpty: Bool {
	  return searchController.searchBar.text?.isEmpty ?? true
	}
	
	var isFiltering: Bool {
	  return searchController.isActive && !isSearchBarEmpty
	}
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(ChatRoomTableViewCell.self, forCellReuseIdentifier: ChatRoomTableViewCell.reuserIdentifier)
		tableView.rowHeight = 76
		tableView.separatorStyle = .none
		return tableView
	}()
	
	// MARK: - Lifecycle
	
	init(user: User) {
		self.user = user
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
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		fetchConversations()
	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(tableView)
		tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,
						 right: view.rightAnchor)
	}
	
	func setupNavBar() {
		navigationController?.navigationBar.isHidden = false
		navigationItem.title = "Messages"
		let titleAttribute: [NSAttributedString.Key: Any] = [
			.font: UIFont.customFont(.interBold, size: 16)
		]
		let appearance = UINavigationBarAppearance()
		appearance.titleTextAttributes = titleAttribute
		appearance.configureWithDefaultBackground()
		navigationController?.navigationBar.standardAppearance = appearance
		navigationController?.navigationBar.compactAppearance = appearance
		navigationController?.navigationBar.scrollEdgeAppearance = appearance
		tabBarController?.tabBar.isHidden = true
		let leftImage = UIImage.asset(.chevron_left)?.withRenderingMode(.alwaysOriginal).withTintColor(.dark40)
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftImage, style: .done, target: self, action: #selector(popVC))
		
		setupSearchController()
	}
	
	func setupSearchController() {
		UISearchBar.appearance().barTintColor = .orange
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search Chat"
		navigationItem.searchController = searchController
		definesPresentationContext = true
	}
	
	// MARK: - Actions
	
	@objc func popVC() {
		navigationController?.popViewController(animated: true)
	}
	
	// MARK: - Helpers
	
	func fetchConversations() {
		ChatService.shared.fetchConversation { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let conversations):
				let filterBlockedUserConversations = conversations.filter { conversation in
					return !self.user.blockedUsers.contains(conversation.user.userID)
				}
				self.conversations = filterBlockedUserConversations
				self.tableView.reloadData()
			case .failure(let error):
				print(error)
			}
		}
	}
	
	func filterContentForSearchText(_ searchText: String) {
		filteredConversations = conversations.filter { conversation -> Bool in
			return conversation.user.name.lowercased().contains(searchText.lowercased())
		}
		tableView.reloadData()
	}
}

// MARK: - UITableViewDataSource

extension ChatRoomViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if isFiltering {
			return filteredConversations.count
		}
		return conversations.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatRoomTableViewCell.reuserIdentifier, for: indexPath)
				as? ChatRoomTableViewCell else { fatalError("Can not dequeue ChatRoomTableViewCell") }
		
		if isFiltering {
			cell.conversation = filteredConversations[indexPath.row]
		} else {
			cell.conversation = conversations[indexPath.row]

		}
		cell.selectionStyle = .none
		return cell
	}
}

// MARK: - UITableViewDelegate

extension ChatRoomViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if isFiltering {
			let filteredConversation = filteredConversations[indexPath.row]
			let chatVC = ChatViewController(receiver: filteredConversation.user, sender: user)
			navigationController?.pushViewController(chatVC, animated: true)
		} else {
			let conversation = conversations[indexPath.row]
			let chatVC = ChatViewController(receiver: conversation.user, sender: user)
			navigationController?.pushViewController(chatVC, animated: true)
		}
	}
}

// MARK: - UISearchControllerDelegate

extension ChatRoomViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		let searchBar = searchController.searchBar
		filterContentForSearchText(searchBar.text!)
	}
}
