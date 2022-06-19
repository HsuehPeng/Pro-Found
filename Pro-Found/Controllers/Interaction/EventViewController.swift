//
//  EventViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/19.
//

import UIKit

class EventViewController: UIViewController {
	
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
	
	var events = [Event]() {
		didSet {
			tableView.reloadData()
		}
	}
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.separatorStyle = .none
		tableView.register(EventListTableViewCell.self, forCellReuseIdentifier: EventListTableViewCell.reuseIdentifier)
		return tableView
	}()
	
	private lazy var writePostButton: UIButton = {
		let button = UIButton()
		let image = UIImage.asset(.add)?.withTintColor(UIColor.orange)
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
		let createEventVC = CreateEventViewController(user: user)
		createEventVC.modalPresentationStyle = .fullScreen
		present(createEventVC, animated: true)
	}
	
	// MARK: - Helpers
    
}

// MARK: - UITableViewDataSource

extension EventViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return 5
		return events.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: EventListTableViewCell.reuseIdentifier, for: indexPath)
				as? EventListTableViewCell else { fatalError("Can not dequeue EventListTableViewCell") }
		let event = events[indexPath.row]
		cell.event = event
		cell.delegate = self
		return cell
	}
	
}

// MARK: - UITableViewDelegate

extension EventViewController: UITableViewDelegate {
	
}

// MARK: - EventListTableViewCellDelegate

extension EventViewController: EventListTableViewCellDelegate {
	
	func bookEvent(_ cell: EventListTableViewCell) {
		guard let user = user, let event = cell.event else { return }
		UserServie.shared.uploadScheduledEvent(participantID: user.userID, eventID: event.eventID, time: event.timestamp) {
			cell.bookEventButton.isEnabled = false
			cell.bookEventButton.backgroundColor = .dark20
		}
	}
	
}
