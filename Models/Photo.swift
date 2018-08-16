//
//  Photo.swift
//  JStrawn_Photos
//
//  Created by Jay Strawn on 7/1/18.
//  Copyright © 2018 Jay Strawn. All rights reserved.
//

import UIKit

public class Photo: Codable {
  var albumId: Int
  var id: Int
  var title: String
  var url: String
  var thumbnailUrl: String
  
  init(albumId: Int, id: Int, title: String, url: String, thumbnailUrl: String) {
    self.albumId = albumId
    self.id = id
    self.title = title
    self.url = url
    self.thumbnailUrl = thumbnailUrl
  }
}
