//
//  UIColor.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/12.
//

import UIKit

private enum STColor: String {
	
	// OceanColor
	
	case ocean
	case ocean10
	case ocean20
	case ocean30
	case ocean40
	case ocean50
	case ocean60
	
	// DarkColor
	case dark
	case dark10
	case dark20
	case dark30
	case dark40
	case dark50
	case dark60
	
	// OrangeColor
	
	case orange
	case orange10
	case orange20
	case orange30
	case orange40
	case orange50
	case orange60
	
}

extension UIColor {
	
	static let ocean = STColor(.ocean)
	static let ocean10 = STColor(.ocean10)
	static let ocean20 = STColor(.ocean20)
	static let ocean30 = STColor(.ocean30)
	static let ocean40 = STColor(.ocean40)
	static let ocean50 = STColor(.ocean50)
	static let ocean60 = STColor(.ocean60)
	
	static let orange = STColor(.orange)
	static let orange10 = STColor(.orange10)
	static let orange20 = STColor(.orange20)
	static let orange30 = STColor(.orange30)
	static let orange40 = STColor(.orange40)
	static let orange50 = STColor(.orange50)
	static let orange60 = STColor(.orange60)
	
	static let dark = STColor(.dark)
	static let dark10 = STColor(.dark10)
	static let dark20 = STColor(.dark20)
	static let dark30 = STColor(.dark30)
	static let dark40 = STColor(.dark40)
	static let dark50 = STColor(.dark50)
	static let dark60 = STColor(.dark60)
	
	private static func STColor(_ color: STColor) -> UIColor {

		return UIColor(named: color.rawValue) ?? .orange
	}
	
	static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
		return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
	}
	
	static func hexStringToUIColor(hex: String) -> UIColor {

		var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

		if cString.hasPrefix("#") {
			cString.remove(at: cString.startIndex)
		}

		if (cString.count) != 6 {
			return UIColor.gray
		}

		var rgbValue: UInt64 = 0
		Scanner(string: cString).scanHexInt64(&rgbValue)

		return UIColor(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
	}
}
