//
//  ImageCache.swift
//  JStrawn_Photos
//
//  Created by Jay Strawn on 6/29/18.
//  Copyright © 2018 Jay Strawn. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
  
  func loadImageUsingCacheWithURLString(urlString: String) {
    
    self.image = nil
    
    if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
      self.image = cachedImage
      return
    }
      
    else {
      let url = URL(string: urlString)
      URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
        
        if error != nil {
          print(error.debugDescription)
        }
        else {
          DispatchQueue.main.async {
            if let downloadedImage = UIImage(data: data!) {
              
              imageCache.setObject(downloadedImage, forKey: urlString as NSString)
              self.image = downloadedImage
            }
          }
        }
      }).resume()
    }
  }
}
