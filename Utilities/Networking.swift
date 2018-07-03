//
//  Networking.swift
//  JStrawn_Photos
//
//  Created by Jay Strawn on 6/26/18.
//  Copyright © 2018 Jay Strawn. All rights reserved.
//

import UIKit

public class Networking {
  
  static let sharedInstance = Networking()
  
  var delegate: ReloadCollectionViewDelegate?
  var photos = [Photo]()
  
  func getPhotosInformation() {
    let jsonString = "http://jsonplaceholder.typicode.com/photos"
    
    guard let url = URL(string: jsonString) else { return }
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      guard let data = data else { return }
      do {
        let decoder = JSONDecoder()
        let photoData = try decoder.decode([PhotoRawInfo].self, from: data)
        self.photos.removeAll()
        for photo in photoData {
          let albumId = photo.albumId
          let id = photo.id
          let title = photo.title
          let url = photo.url
          let thumbnailUrl = photo.thumbnailUrl
          
          let photoObject = Photo(albumId: albumId, id: id, title: title, url: url, thumbnailUrl: thumbnailUrl)
          self.photos.append(photoObject)
        }
      } catch let error {
        print("Error", error)
      }
      let success = error == nil
      self.delegate?.didGetResult(success)
      }.resume()
  }
}
