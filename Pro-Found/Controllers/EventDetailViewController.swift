//
//  EventDetailViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/20.
//

import UIKit
import FirebaseAuth
import CoreLocation
import MapKit

class EventDetailViewController: UIViewController {

	// MARK: - Properties
	
	let event: Event
	
	let user: User
	
	var isFollow: Bool? {
		didSet {
			tableView.reloadData()
		}
	}
	
	var eventLocation: CLLocation?
	
	private let tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped)
		tableView.separatorStyle = .none
		tableView.register(EventDetailListTableViewCell.self, forCellReuseIdentifier: EventDetailListTableViewCell.reuseIdentifier)
		tableView.register(GeneralMapCellTableViewCell.self, forCellReuseIdentifier: GeneralMapCellTableViewCell.reuseIdentifier)
		tableView.register(EventDetailContentTableViewCell.self, forCellReuseIdentifier: EventDetailContentTableViewCell.reuseIdentifier)
		tableView.register(EventDetailTableViewHeader.self, forHeaderFooterViewReuseIdentifier: EventDetailTableViewHeader.reuseIdentifier)
		return tableView
	}()
	
	private let bottomBarView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		return view
	}()
	
	private lazy var scheduleEventButton: UIButton = {
		let button = CustomUIElements().makeLargeButton(buttonColor: .orange, buttonTextColor: .white, borderColor: .clear, buttonText: "Book Event")
		button.setTitle("Booked", for: .disabled)
		button.addTarget(self, action: #selector(handleBookEvent), for: .touchUpInside)
		button.widthAnchor.constraint(equalToConstant: 200).isActive = true
		return button
	}()
	
	// MARK: - Lifecycle
	
	init(event: Event, user: User) {
		self.event = event
		self.user = user
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		
		tableView.dataSource = self
		tableView.delegate = self
		
		setupUI()
		convertAdressToCLLocation()
		checkIfFollowed()
		checkIfEventBooked()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavBar()
	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(tableView)
		tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
		
		view.addSubview(bottomBarView)
		bottomBarView.anchor(top: tableView.bottomAnchor ,left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, height: 78)
		
		bottomBarView.addSubview(scheduleEventButton)
		scheduleEventButton.centerY(inView: bottomBarView)
		scheduleEventButton.rightAnchor.constraint(equalTo: bottomBarView.rightAnchor, constant: -16).isActive = true
	}
	
	func setupNavBar() {
		let titleAttribute: [NSAttributedString.Key: Any] = [
			.font: UIFont.customFont(.interBold, size: 16)
		]
		let appearance = UINavigationBarAppearance()
		appearance.titleTextAttributes = titleAttribute
		appearance.configureWithDefaultBackground()
		navigationController?.navigationBar.standardAppearance = appearance
		navigationController?.navigationBar.isHidden = false
		title = "Event Detail"
		let leftItemImage = UIImage.asset(.chevron_left)?.withRenderingMode(.alwaysOriginal)
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftItemImage, style: .done, target: self, action: #selector(popVC))
		tabBarController?.tabBar.isHidden = true
	}
	
	// MARK: - Actions
	
	@objc func handleBookEvent() {
		UserServie.shared.uploadScheduledEvent(participantID: user.userID, eventID: event.eventID, time: event.timestamp) { [weak self] in
			guard let self = self else { return }
			self.scheduleEventButton.isEnabled = false
			self.scheduleEventButton.backgroundColor = .dark20
		}
	}
	
	@objc func popVC() {
		navigationController?.popViewController(animated: true)
	}
	
	// MARK: - Helpers
	
	func checkIfEventBooked() {
		if event.participants.contains(user.userID) {
			scheduleEventButton.backgroundColor = .dark20
			scheduleEventButton.isEnabled = false
		}
	}
	
	func checkIfFollowed() {
		UserServie.shared.checkIfFollow(senderID: user.userID, receiveriD: event.organizer.userID) { [weak self] bool in
			guard let self = self else { return }
			self.isFollow = bool
		}
	}
	
	func convertAdressToCLLocation() {
		let address = event.location
		let geoCoder = CLGeocoder()
		
		geoCoder.geocodeAddressString(address) { (placemarks, error) in
			guard
				let placemarks = placemarks,
				let location = placemarks.first?.location
			else {
				print("No location found: \(String(describing: error))")
				return
			}
			self.eventLocation = location
		}
	}
}

// MARK: - UITableViewDataSource

extension EventDetailViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let listCell = tableView.dequeueReusableCell(withIdentifier: EventDetailListTableViewCell.reuseIdentifier, for: indexPath)
				as? EventDetailListTableViewCell else { fatalError("Can not dequeue CourseDetailListTableViewCell") }
		
		guard let mapCell = tableView.dequeueReusableCell(withIdentifier: GeneralMapCellTableViewCell.reuseIdentifier, for: indexPath)
				as? GeneralMapCellTableViewCell else { fatalError("Can not dequeue GeneralMapCellTableViewCell") }
		
		guard let detailCell = tableView.dequeueReusableCell(withIdentifier: EventDetailContentTableViewCell.reuseIdentifier, for: indexPath)
				as? EventDetailContentTableViewCell else { fatalError("Can not dequeue EventDetailContentTableViewCell") }
		
		if indexPath.section == 0 {
			listCell.delegate = self
			listCell.isFollow = isFollow
			listCell.event = event
			return listCell
		} else if indexPath.section == 1 {
			mapCell.eventLocation = eventLocation
			return mapCell
		} else {
			return detailCell
		}
	}
}

// MARK: - UITableViewDelegate

extension EventDetailViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 1 {
			guard let eventLocation = eventLocation else { return }
			let mapVC = MapViewController(location: eventLocation)
			navigationController?.pushViewController(mapVC, animated: true)
		}
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: EventDetailTableViewHeader.reuseIdentifier)
				as? EventDetailTableViewHeader else { return nil }
		
		if section == 0 {
			header.event = event
			return header
		}
		
		return nil
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 0 {
			return 50
		} else {
			return 0
		}
	}
}

// MARK: - EventDetailListTableViewCellDelegate

extension EventDetailViewController: EventDetailListTableViewCellDelegate {
	func handleFollowing(_ cell: EventDetailListTableViewCell) {
		guard let isFollow = cell.isFollow, let uid = Auth.auth().currentUser?.uid else { return }
		if isFollow {
			UserServie.shared.unfollow(senderID: uid, receiverID: event.organizer.userID)
			cell.followButton.setTitle("Follow", for: .normal)
			self.isFollow = false
		} else {
			UserServie.shared.follow(senderID: uid, receiverID: event.organizer.userID)
			cell.followButton.setTitle("Unfollow", for: .normal)
			self.isFollow = true
		}
	}
}
