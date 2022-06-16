//
//  ScheduleViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/13.
//

import UIKit

class ScheduleViewController: UIViewController {

	// MARK: - Properties
	
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

		let width = (UIScreen.main.bounds.width - 32) / 8
		let height = 30
		flowLayout.scrollDirection = .vertical
		flowLayout.itemSize = CGSize(width: Int(width), height: height)
		flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
		flowLayout.minimumInteritemSpacing = 2
		collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.reuseIdentifier)

		return collectionView
	}()
	
	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		
		collectionView.dataSource = self
		collectionView.delegate = self
		
		setupNavBar()
		setupUI()
		setMonthView()
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
		
		let monthSwitchHStack = UIStackView(arrangedSubviews: [previousMonthButton, monthLabel, nextMonthButton])
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
		collectionView.anchor(top: weekdayHStack.bottomAnchor, left: view.leftAnchor,
							  bottom: view.bottomAnchor, right: view.rightAnchor)
		
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
	
	func setMonthView() {
		totalSquares.removeAll()
		let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
		let firstDayOfMonth = CalendarHelper().firstOfMonth(date: selectedDate)
		let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)
		
		var count: Int = 1
		
		while count <= 42 {
			if count <= startingSpaces || count - startingSpaces > daysInMonth {
				totalSquares.append("")
				count += 1
			} else {
				totalSquares.append(String(count - startingSpaces))
				count += 1
			}
		}
		
		monthLabel.text = CalendarHelper().monthString(date: selectedDate) + " " + CalendarHelper().yearString(date: selectedDate)
		collectionView.reloadData()
	}
	
}

// MARK: - UICollectionViewDataSource

extension ScheduleViewController: UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return totalSquares.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.reuseIdentifier, for: indexPath)
		as? CalendarCollectionViewCell else { return UICollectionViewCell() }
		cell.dateLabel.text = totalSquares[indexPath.item]
		return cell
	}

}

// MARK: - UICollectionViewDelegate

extension ScheduleViewController: UICollectionViewDelegate {

}
