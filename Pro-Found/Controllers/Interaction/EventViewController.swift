//
//  EventViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/19.
//

import UIKit

class EventViewController: UIViewController {
	
	// MARK: - Properties
	
	var events = [Event]()
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.separatorStyle = .none
		tableView.register(EventListTableViewCell.self, forCellReuseIdentifier: EventListTableViewCell.reuseIdentifier)
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
	
	// MARK: - Actions
	
	// MARK: - Helpers
    
}

// MARK: - UITableViewDataSource

extension EventViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
//		return events.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: EventListTableViewCell.reuseIdentifier, for: indexPath)
				as? EventListTableViewCell else { fatalError("Can not dequeue EventListTableViewCell") }
		return cell
	}
	
}

// MARK: - UITableViewDelegate

extension EventViewController: UITableViewDelegate {
	
}
