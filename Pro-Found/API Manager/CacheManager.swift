//
//  cacheManager.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/7/4.
//

import Foundation

class CacheManager {

	static let shared = CacheManager()

	private let fileManager = FileManager.default

	private lazy var mainDirectoryUrl: URL = {

		let documentsUrl = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
		return documentsUrl
	}()

	func getFileWith(stringUrl: String, completionHandler: @escaping (Result<URL, Error>) -> Void ) {

		let file = directoryFor(stringUrl: stringUrl)

		//return file path if already exists in cache directory
		guard !fileManager.fileExists(atPath: file.path)  else {
			completionHandler(Result.success(file))
			return
		}

		DispatchQueue.global().async {

			if let videoData = NSData(contentsOf: URL(string: stringUrl)!) {
				videoData.write(to: file, atomically: true)
				
				DispatchQueue.main.async {
					completionHandler(Result.success(file))
				}
			}
		}
	}

	private func directoryFor(stringUrl: String) -> URL {

		let fileURL = URL(string: stringUrl)!.lastPathComponent

		let file = self.mainDirectoryUrl.appendingPathComponent(fileURL).appendingPathExtension("mp4")

		return file
	}
}
