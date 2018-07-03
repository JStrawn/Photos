//
//  PhotoRawInfo.swift
//  JStrawn_Photos
//
//  Created by Jay Strawn on 6/26/18.
//  Copyright © 2018 Jay Strawn. All rights reserved.
//

import Foundation

public struct PhotoRawInfo: Codable {
  var albumId: Int
  var id: Int
  var title: String
  var url: String
  var thumbnailUrl: String
}
