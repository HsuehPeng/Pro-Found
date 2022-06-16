//
//  CalendarHelper.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/16.
//

import UIKit

struct CalendarHelper {
	let calendar = Calendar.current
	
	func plusMonth(date: Date) -> Date {
		return calendar.date(byAdding: .month, value: 1, to: date) ?? Date()
	}
	
	func minusMonth(date: Date) -> Date {
		return calendar.date(byAdding: .month, value: -1, to: date) ?? Date()
	}
	
	func monthString(date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "LLLL"
		return dateFormatter.string(from: date)
	}
	
	func yearString(date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy"
		return dateFormatter.string(from: date)
	}
	
	func daysInMonth(date: Date) -> Int {
		let range = calendar.range(of: .day, in: .month, for: date)
		return range!.count
	}
	
	func daysOfMonth(date: Date) -> Int {
		let components = calendar.dateComponents([.day], from: date)
		return components.day!
	}
	
	func firstOfMonth(date: Date) -> Date {
		let components = calendar.dateComponents([.year, .month], from: date)
		return calendar.date(from: components)!
	}
	
	func weekDay(date: Date) -> Int {
		let components = calendar.dateComponents([.weekday], from: date)
		return components.weekday! - 1
	}
	
}
