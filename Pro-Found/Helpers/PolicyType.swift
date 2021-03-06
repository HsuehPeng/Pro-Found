//
//  PolicyType.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/7/5.
//

enum PolicyType {
	
	case privacyPolicy
	
	case eula
	
	var url: String {
		
		switch self {
			
		case .privacyPolicy:
			return "https://www.termsfeed.com/live/474dfa37-d4ef-47ed-a5b3-9f6164ea89ce"
			
		case .eula:
			return "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
		}
	}
}
