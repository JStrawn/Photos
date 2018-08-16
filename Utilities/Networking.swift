////
////  Networking.swift
////  JStrawn_Photos
////
////  Created by Jay Strawn on 6/26/18.
////  Copyright © 2018 Jay Strawn. All rights reserved.
////

import UIKit

enum WebServiceError: Error {
  case DataEmptyError
  case ResponseError
}

protocol SessionProtocol {
  func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void ) -> URLSessionDataTask
}

class Networking {
  
  lazy var session: SessionProtocol = URLSession.shared
  
  static let sharedInstance = Networking()
  
  var delegate: ReloadCollectionViewDelegate?
  var jsonString: String?
  var photos = [Photo]()
  
  func getPhotosInformation(completion: @escaping (Error?) -> Void) {
    
    jsonString = "http://jsonplaceholder.typicode.com/photos"
    
    
    guard let url = URL(string: jsonString!) else { fatalError() }
    session.dataTask(with: url) { (data, response, error) in
      
      guard error == nil else {
        completion(WebServiceError.ResponseError)
        return
      }
      guard let data = data else {
        completion(WebServiceError.DataEmptyError)
        return
      }
      
      do {
        let decoder = JSONDecoder()
        self.photos = try decoder.decode([Photo].self, from: data)
      } catch let error {
        print("Error", error)
      }
      let success = error == nil
      self.delegate?.didGetResult(success)
      }.resume()
  }
}

extension URLSession: SessionProtocol {
}
