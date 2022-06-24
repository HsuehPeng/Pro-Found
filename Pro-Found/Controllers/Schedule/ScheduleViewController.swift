//
//  ScheduleViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/13.
//

import UIKit
import FirebaseAuth

class ScheduleViewController: UIViewController {

	// MARK: - Properties
	
	var user: User? {
		didSet {
			guard let user = user else { return }
			fetchScheduledCourseAndEventIDs(user: user)
		}
	}
	
	var scheduledCourses = [Course]()
	var scheduledCoursesIdWithTimes = [ScheduledCourseTime]()
	var filteredScheduledCourses = [Course]() {
		didSet {
			tableView.reloadData()
		}
	}
	
	var scheduledEvents = [Event]()
	var scheduledEventIdWithTimes = [ScheduledEventTime]()
	var filteredScheduledEvents = [Event]() {
		didSet {
			tableView.reloadData()
		}
	}

	var seletedTableCellIndexPath: IndexPath = IndexPath(item: 0, section: 0) {
		didSet {
			guard let selectedCell = collectionView.cellForItem(at: seletedTableCellIndexPath) as? CalendarCollectionViewCell else { return }
			guard let previousCell = collectionView.cellForItem(at: oldValue) as? CalendarCollectionViewCell else { return }
			previousCell.backGroundView.backgroundColor = .clear
			selectedCell.backGroundView.backgroundColor = .orange
		}
	}
	
	var selectedDate = Date()
	var totalSquares = [String]()
	
	private let topBarView: UIView = {
		let view = UIView()
		return view
	}()
	
	private let pageTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 24),
												 textColor: UIColor.dark60, text: "Schedule")
		return label
	}()
	
	private var monthLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 12), textColor: .dark40, text: "Month")
		return label
	}()
	
	private var yearLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 12), textColor: .dark40, text: "Year")
		return label
	}()
	
	private lazy var nextMonthButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.asset(.chevron_right), for: .normal)
		button.setDimensions(width: 16, height: 16)
		button.addTarget(self, action: #selector(goNextMonth), for: .touchUpInside)
		return button
	}()
	
	private lazy var previousMonthButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.asset(.chevron_left), for: .normal)
		button.setDimensions(width: 16, height: 16)
		button.addTarget(self, action: #selector(goPreviousMonth), for: .touchUpInside)
		return button
	}()
	
	private lazy var switchMonthWeekButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.asset(.article), for: .normal)
		return button
	}()
	
	private let sundayLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 10),
												 textColor: UIColor.dark, text: "SUN")
		label.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 32) / 8).isActive = true
		label.textAlignment = .center
		return label
	}()
	
	private let mondayLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 10),
												 textColor: UIColor.dark, text: "MON")
		label.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 32) / 8).isActive = true
		label.textAlignment = .center
		return label
	}()
	
	private let tuesdayLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 10),
												 textColor: UIColor.dark, text: "TUE")
		label.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 32) / 8).isActive = true
		label.textAlignment = .center
		return label
	}()
	
	private let wednesdayLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 10),
												 textColor: UIColor.dark, text: "WED")
		label.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 32) / 8).isActive = true
		label.textAlignment = .center
		return label
	}()
	
	private let thursdayLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 10),
												 textColor: UIColor.dark, text: "THU")
		label.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 32) / 8).isActive = true
		label.textAlignment = .center
		return label
	}()
	
	private let fridayLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 10),
												 textColor: UIColor.dark, text: "FRI")
		label.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 32) / 8).isActive = true
		label.textAlignment = .center
		return label
	}()
	
	private let saturadayLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 10),
												 textColor: UIColor.dark, text: "SAT")
		label.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 32) / 8).isActive = true
		label.textAlignment = .center
		return label
	}()
	
	private let collectionView: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout()
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

		flowLayout.scrollDirection = .vertical
		flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
		flowLayout.minimumInteritemSpacing = 2
		collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.reuseIdentifier)

		return collectionView
	}()
	
	private let tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped)
		tableView.backgroundColor = .light60
		tableView.register(ScheduleCourseListTableCell.self, forCellReuseIdentifier: ScheduleCourseListTableCell .reuseIdentifier)
		tableView.register(ScheduleEventListTableViewCell.self, forCellReuseIdentifier: ScheduleEventListTableViewCell.reuseIdentifier)
		tableView.register(GeneralTableViewHeader.self, forHeaderFooterViewReuseIdentifier: GeneralTableViewHeader.reuseIdentifier)
		return tableView
	}()
	
	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		
		collectionView.dataSource = self
		collectionView.delegate = self
		tableView.dataSource = self
		tableView.delegate = self
		
		setupNavBar()
		setupUI()
		setMonthView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		navigationController?.navigationBar.isHidden = true
		tabBarController?.tabBar.isHidden = false
		fetchUserData()
	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(topBarView)
		topBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
						  right: view.rightAnchor, height: 48)
		
		view.addSubview(pageTitleLabel)
		pageTitleLabel.anchor(left: topBarView.leftAnchor, paddingLeft: 16)
		pageTitleLabel.centerY(inView: topBarView)
		
		topBarView.addSubview(switchMonthWeekButton)
		switchMonthWeekButton.anchor(right: topBarView.rightAnchor, paddingRight: 16)
		switchMonthWeekButton.centerY(inView: topBarView)
		
		let monthSwitchHStack = UIStackView(arrangedSubviews: [previousMonthButton, monthLabel, yearLabel, nextMonthButton])
		monthSwitchHStack.axis = .horizontal
		monthSwitchHStack.spacing = 10
		monthSwitchHStack.distribution = .equalSpacing

		topBarView.addSubview(monthSwitchHStack)
		monthSwitchHStack.anchor(right: switchMonthWeekButton.leftAnchor, paddingRight: 12)
		monthSwitchHStack.centerY(inView: topBarView)
		
		let weekdayHStack = UIStackView(arrangedSubviews: [
			sundayLabel, mondayLabel, tuesdayLabel,
			wednesdayLabel, thursdayLabel, fridayLabel, saturadayLabel
		])
		weekdayHStack.axis = .horizontal
		weekdayHStack.distribution = .equalSpacing
		view.addSubview(weekdayHStack)
		weekdayHStack.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
							 paddingTop: 24, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(collectionView)
		collectionView.anchor(top: weekdayHStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 250)
		
		view.addSubview(tableView)
		tableView.anchor(top: collectionView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
						 right: view.rightAnchor)
		
	}
	
	func setupNavBar() {
		navigationController?.navigationBar.isHidden = true
	}
	
	// MARK: - Actions
	
	@objc func goNextMonth() {
		selectedDate = CalendarHelper().plusMonth(date: selectedDate)
		setMonthView()
	}
	
	@objc func goPreviousMonth() {
		selectedDate = CalendarHelper().minusMonth(date: selectedDate)
		setMonthView()
	}
	
	// MARK: - Helpers
	
	func fetchUserData() {
		guard let userID = Auth.auth().currentUser?.uid else { return }
		UserServie.shared.getUserData(uid: userID) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let user):
				self.user = user
			case .failure(let error):
				print(error)
			}
		}
	}
	
	func fetchScheduledCourseAndEventIDs(user: User) {
		let group = DispatchGroup()
		
		group.enter()
		UserServie.shared.getScheduledCourseIDs(userID: user.userID) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let scheduledCoursesIdWithTimes):
				let sorted = scheduledCoursesIdWithTimes.sorted(by: { $0.time < $1.time })
				self.scheduledCoursesIdWithTimes = sorted
			case .failure(let error):
				print(error)
			}
			group.leave()
		}
		group.enter()
		UserServie.shared.getScheduledEventIDs(userID: user.userID) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let scheduledEventIdWithTimes):
				let sorted = scheduledEventIdWithTimes.sorted(by: { $0.time < $1.time })
				self.scheduledEventIdWithTimes = sorted
			case .failure(let error):
				print(error)
			}
			group.leave()
		}
		
		group.notify(queue: DispatchQueue.global()) {
			self.fetchScheduledCoursesAndEvents(user: user)
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
		
	}
	
	func fetchScheduledCoursesAndEvents(user: User) {
		
		for scheduledCoursesIdWithTime in scheduledCoursesIdWithTimes {
			CourseServie.shared.fetchCourse(courseID: scheduledCoursesIdWithTime.courseID) { [weak self] result in
				guard let self = self else { return }
				switch result {
				case .success(let course):
					self.scheduledCourses.append(course)
				case . failure(let error):
					print(error)
				}
			}
		}
		
		for scheduledEventIdWithTime in scheduledEventIdWithTimes {
			EventService.shared.fetchEvent(user: user, eventID: scheduledEventIdWithTime.eventID) { [weak self] result in
				guard let self = self else { return }
				switch result {
				case .success(let event):
					self.scheduledEvents.append(event)
				case . failure(let error):
					print(error)
				}
			}
		}
	}
	
	func filterCourseAndEventByDate(dateString: String) {
		
		filteredScheduledCourses.removeAll()
		filteredScheduledEvents.removeAll()
		
		let formatter = DateFormatter()
		formatter.dateFormat = "dd MMMM yyyy"
		
		let filteredCoursesIdWithTimes = scheduledCoursesIdWithTimes.filter { scheduledCourseTime in
			let date = Date(timeIntervalSince1970: scheduledCourseTime.time)
			let courseTimeString = formatter.string(from: date)
			if courseTimeString == dateString {
				return true
			} else {
				return false
			}
		}
		
		filteredCoursesIdWithTimes.forEach { scheduledCourseIdWithTime in
			for i in 0..<scheduledCourses.count {
				if scheduledCourseIdWithTime.courseID == scheduledCourses[i].courseID {
					filteredScheduledCourses.append(scheduledCourses[i])
					break
				}
			}
		}
		
		let filteredEventsIdWithTimes = scheduledEventIdWithTimes.filter { scheduledEventTime in
			let date = Date(timeIntervalSince1970: scheduledEventTime.time)
			let eventTimeString = formatter.string(from: date)
			if eventTimeString == dateString {
				return true
			} else {
				return false
			}
		}
		
		filteredEventsIdWithTimes.forEach { scheduledEventIdWithTime in
			for i in 0..<scheduledEvents.count {
				if scheduledEventIdWithTime.eventID == scheduledEvents[i].eventID {
					filteredScheduledEvents.append(scheduledEvents[i])
					break
				}
			}
		}
	}
	
	func setMonthView() {
		totalSquares.removeAll()
		
		let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
		let firstDayOfMonth = CalendarHelper().firstOfMonth(date: selectedDate)
		let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)
		
		var count: Int = 1
		
		while(count <= 42) {
			if(count <= startingSpaces || count - startingSpaces > daysInMonth) {
				totalSquares.append("")
			} else {
				totalSquares.append(String(count - startingSpaces))
			}
			count += 1
		}
		monthLabel.text = CalendarHelper().monthString(date: selectedDate)
		yearLabel.text = CalendarHelper().yearString(date: selectedDate)
		collectionView.reloadData()
	}
	
}

// MARK: - UICollectionViewDataSource

extension ScheduleViewController: UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return totalSquares.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let calendarCell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.reuseIdentifier, for: indexPath)
				as? CalendarCollectionViewCell else { fatalError("Can not dequeue CalendarCollectionViewCell") }
		
//		guard let monthAndYear = monthLabel.text, let year = yearLabel.text else { fatalError("Can not dequeue CalendarCollectionViewCell") }
		calendarCell.backGroundView.backgroundColor = .clear
		calendarCell.badgeDot.isHidden = true
		calendarCell.dateLabel.text = totalSquares[indexPath.item]
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd MMMM yyyy"
		let dateString = "\(totalSquares[indexPath.item]) \(monthLabel.text ?? "") \(yearLabel.text ?? "")"
		
		for scheduleEvent in scheduledEventIdWithTimes {
			let date = Date(timeIntervalSince1970: scheduleEvent.time)
			let eventDateString = dateFormatter.string(from: date)
			if eventDateString == dateString {
				calendarCell.badgeDot.isHidden = false
			}
		}
		
		for scheduleCourse in scheduledCoursesIdWithTimes {
			let date = Date(timeIntervalSince1970: scheduleCourse.time)
			let courseDateString = dateFormatter.string(from: date)
			if courseDateString == dateString {
				calendarCell.badgeDot.isHidden = false
			}
		}

		return calendarCell
	}

}

// MARK: - UICollectionViewDelegate

extension ScheduleViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell else { return }
		guard let monthAndYear = monthLabel.text, let day = cell.dateLabel.text, let year = yearLabel.text else { return }
		
		seletedTableCellIndexPath = indexPath

		let dateString = "\(day) \(monthAndYear) \(year)"
		filterCourseAndEventByDate(dateString: dateString)

	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
		if indexPath.section == 0 {
			let width = (UIScreen.main.bounds.width - 32) / 8
			let height = 30
			return CGSize(width: Int(width), height: height)
		}
		return CGSize(width: UIScreen.main.bounds.width, height: 128)
	}
}

// MARK: - UITableViewDataSource

extension ScheduleViewController: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return filteredScheduledCourses.count
		} else {
			return filteredScheduledEvents.count
		}
	}


	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let eventCell = tableView.dequeueReusableCell(withIdentifier: ScheduleEventListTableViewCell.reuseIdentifier, for: indexPath)
				as? ScheduleEventListTableViewCell else { fatalError("Can not dequeue EventListTableViewCell") }
		guard let courseCell = tableView.dequeueReusableCell(withIdentifier: ScheduleCourseListTableCell.reuseIdentifier, for: indexPath)
				as? ScheduleCourseListTableCell else { fatalError("Can not dequeue ScheduleCourseListTableCell") }
		
		if indexPath.section == 0 {
			courseCell.course = filteredScheduledCourses[indexPath.row]
			return courseCell
		} else {
			eventCell.event = filteredScheduledEvents[indexPath.row]
			return eventCell
		}

	}

}

// MARK: - UITableViewDelegate

extension ScheduleViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let user = user else { return }
		
		if indexPath.section == 0 {
			let course = filteredScheduledCourses[indexPath.row]
			let courseDetailVC = CourseDetailViewController(course: course, user: user)
			navigationController?.pushViewController(courseDetailVC, animated: true)
		} else {
			let event = filteredScheduledEvents[indexPath.row]
			let eventDetailVC = EventDetailViewController(event: event, user: user)
			navigationController?.pushViewController(eventDetailVC, animated: true)
		}
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: GeneralTableViewHeader.reuseIdentifier)
				as? GeneralTableViewHeader else { fatalError("Can not dequeue GeneralTableViewHeader") }
		header.seeAllButton.isHidden = true
		
		if section == 0 {
			header.titleLabel.text = "Courses"
		} else {
			header.titleLabel.text = "Events"
		}
		return header
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
}
