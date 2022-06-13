//
//  ImageAsset+UIImageExtension.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/12.
//

import UIKit

enum ImageAsset: String {
	
	// MARK: - Icon
	
	// swiftlint:disable identifier_name
	
	case account_add_friends
	case account_add_group
	case account_circle
	case account_face
	case account_group
	case account_person
	case account_pin
	case add_circle
	case add
	case alert_error
	case alert_info
	case alert_warning
	case arrow_down
	case arrow_left
	case arrow_right
	case arrow_up
	case article
	case assignment
	case attach_file
	case bookmark
	case calendar_selected
	case calendar_time
	case calendar_today
	case calendar
	case call
	case camera_flash_off
	case camera_flash_on
	case camera_rotate
	case camera_switch
	case camera_videocam_off
	case camera_videocam
	case camera
	case card_score
	case chat_new
	case chat
	case check_box_blank
	case check_box
	case check_circle
	case chevron_down
	case chevron_left
	case chevron_right
	case chevron_up
	case close_circle
	case close
	case coin
	case control_radio_checked
	case control_radio_unchecked
	case credit_card
	case dashboard
	case delete
	case dialpad
	case doc
	case download_line
	case download
	case eco
	case edit
	case electrical_bolt
	case electrical_plug
	case electrical_power
	case email
	case emoticon
	case favorite
	case filter
	case folder_shared
	case folder
	case font
	case fullscreen
	case golf_course
	case headset
	case help_center
	case help
	case home
	case layers
	case logout
	case map_gps
	case map_my_location
	case map_navigation
	case map_open_map
	case map_pin
	case media_mic
	case media_pause
	case media_play_circle
	case media_play
	case media_stop
	case media_volume_off
	case media_volume
	case minus
	case more
	case notification_important
	case notifications
	case password_hide
	case password_show
	case password
	case photo
	case print
	case re_refresh
	case re_reload
	case re_sync
	case receipt
	case reply
	case restore
	case screen_share
	case screen_rotation
	case search
	case send
	case settings
	case share
	case shopping_bag
	case shopping_cart
	case shopping_store
	case shopping_tag
	case signal_cellular_off
	case signal_wifi_off
	case star
	case style_fill
	case thumb_down
	case thumb_up
	case transport_bus
	case transport_plane
	case transport_train
	case verified_user
	case verified
	case web
	case work
	
	// Colored Icon
	
	case course
	case document
	case event
	case intern
	case mentor
	case people
	case resume
	case subscribe
}

// MARK: - Extension UIImage

extension UIImage {

	static func asset(_ asset: ImageAsset) -> UIImage? {
		return UIImage(named: asset.rawValue)
	}
}
