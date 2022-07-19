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
import Lottie

class EventDetailViewController: UIViewController {

	// MARK: - Properties
	
	var event: Event
	
	let user: User
	
	var isFollow: Bool? {
		didSet {
			tableView.reloadData()
		}
	}
	
	var participants = [User]()
	
	var eventLocation: CLLocation?
	
	private let tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped)
		tableView.separatorStyle = .none
		tableView.backgroundColor = .light60
		tableView.register(EventDetailListTableViewCell.self, forCellReuseIdentifier: EventDetailListTableViewCell.reuseIdentifier)
		tableView.register(GeneralMapCellTableViewCell.self, forCellReuseIdentifier: GeneralMapCellTableViewCell.reuseIdentifier)
		tableView.register(EventDetailContentTableViewCell.self, forCellReuseIdentifier: EventDetailContentTableViewCell.reuseIdentifier)
		tableView.register(EventDetailTableViewHeader.self, forHeaderFooterViewReuseIdentifier: EventDetailTableViewHeader.reuseIdentifier)
		return tableView
	}()
	
	private let bottomBarView: UIView = {
		let view = UIView()
		view.backgroundColor = .light60
		return view
	}()
	
	private lazy var scheduleEventButton: UIButton = {
		let button = CustomUIElements().makeLargeButton(buttonColor: .orange, buttonTextColor: .light60, borderColor: .clear, buttonText: "Book Event")
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
		view.backgroundColor = .light60
		
		tableView.dataSource = self
		tableView.delegate = self
		
		setupUI()
		convertAdressToCLLocation()
		checkIfFollowed()
		checkIfEventBooked()
		fetchParticipants()
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
		setupAttributeNavBar(titleText: "Event Detail")

		let leftItemImage = UIImage.asset(.chevron_left)?.withRenderingMode(.alwaysOriginal)
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftItemImage, style: .done, target: self, action: #selector(popVC))
		let rightItemImage = UIImage.asset(.more)?.withRenderingMode(.alwaysOriginal)
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightItemImage, style: .plain, target: self, action: #selector(handleReportAction))
	}
	
	// MARK: - Actions
	
	@objc func handleBookEvent() {
		let loadingLottie = Lottie(superView: view, animationView: AnimationView(name: "loadingAnimation"))
		
		if event.participants.contains(user.userID) {
			
			let controller = UIAlertController(title: "Are you sure to unbook this event?", message: nil, preferredStyle: .alert)
			
			let okAction = UIAlertAction(title: "Sure", style: .destructive) { [weak self] _ in
				guard let self = self else { return }
				
				loadingLottie.loadingAnimation()
				
				UserServie.shared.deleteEventParticipant(participantID: self.user.userID, eventID: self.event.eventID) { [weak self] error in
					guard let self = self else { return }
					loadingLottie.stopAnimation()
					
					if let error = error {
						self.showAlert(alertText: "Connection Error", alertMessage: "\(error)")
					} else {
						self.scheduleEventButton.backgroundColor = .orange
						self.scheduleEventButton.setTitle("Book Event", for: .normal)
						self.event.participants.removeAll(where: { $0 == self.user.userID })
					}
				}
			}
			
			let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
			controller.addAction(okAction)
			controller.addAction(cancelAction)
			
			present(controller, animated: true, completion: nil)
			
		} else {
			loadingLottie.loadingAnimation()
			
			UserServie.shared.uploadScheduledEvent(participantID: user.userID, eventID: event.eventID, time: event.timestamp) { [weak self] in
				guard let self = self else { return }
				loadingLottie.stopAnimation()
				
				self.scheduleEventButton.backgroundColor = .dark20
				self.scheduleEventButton.setTitle("Unbook Event", for: .normal)
			}
		}

	}
	
	@objc func popVC() {
		navigationController?.popViewController(animated: true)
	}
	
	@objc func handleReportAction() {
		let actionSheet = UIAlertController(title: "Actions", message: nil,
											preferredStyle: .actionSheet)
		
		let reportAction = UIAlertAction(title: "Report", style: .destructive) { [weak self] action in
			guard let self = self else { return }
			let reportVC = ReportViewController(contentID: self.event.eventID, contentType: ContentTyep.event)
			if let reportSheet = reportVC.presentationController as? UISheetPresentationController {
				reportSheet.detents = [.large()]
			}
			self.present(reportVC, animated: true)
		}
		actionSheet.addAction(reportAction)

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		actionSheet.addAction(cancelAction)
		
		self.present(actionSheet, animated: true, completion: nil)
	}
	
	// MARK: - Helpers
	
	func checkIfEventBooked() {
		if event.participants.contains(user.userID) {
			scheduleEventButton.backgroundColor = .dark20
			scheduleEventButton.setTitle("Unbook Event", for: .normal)

		} else {
			scheduleEventButton.backgroundColor = .orange
			scheduleEventButton.setTitle("Book Event", for: .normal)
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
	
	func fetchParticipants() {
		let group = DispatchGroup()
		
		for participantID in event.participants {
			group.enter()
			UserServie.shared.getUserData(uid: participantID) { [weak self] result in
				guard let self = self else { return }
				switch result {
				case .success(let user):
					self.participants.append(user)
				case .failure(let error):
					print(error)
				}
				group.leave()
			}
		}
		
		group.notify(queue: DispatchQueue.main) {
			self.tableView.reloadData()
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
			listCell.selectionStyle = .none
			listCell.isFollow = isFollow
			listCell.event = event
			return listCell
		} else if indexPath.section == 1 {
			mapCell.event = event
			mapCell.eventLocation = eventLocation
			mapCell.selectionStyle = .none
			return mapCell
		} else {
			detailCell.event = event
			detailCell.participants = participants
			detailCell.selectionStyle = .none
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
	func goToPublicProfile(_ cell: EventDetailListTableViewCell) {
		guard let event = cell.event else { return }
		let tutorProfileVC = TutorProfileViewController(user: user, tutor: event.organizer)
		navigationController?.pushViewController(tutorProfileVC, animated: true)
	}
	
	func handleFollowing(_ cell: EventDetailListTableViewCell) {
		guard let isFollow = cell.isFollow, let uid = Auth.auth().currentUser?.uid else { return }
		
		let loadingLottie = Lottie(superView: view, animationView: AnimationView.init(name: "loadingAnimation"))
		loadingLottie.loadingAnimation()
		
		if isFollow {
			UserServie.shared.unfollow(senderID: uid, receiverID: event.organizer.userID) {
				loadingLottie.stopAnimation()
			}
			cell.followButton.setTitle("Follow", for: .normal)
			self.isFollow = false
		} else {
			UserServie.shared.follow(senderID: uid, receiverID: event.organizer.userID) {
				loadingLottie.stopAnimation()
			}
			cell.followButton.setTitle("Unfollow", for: .normal)
			self.isFollow = true
		}
	}
}
