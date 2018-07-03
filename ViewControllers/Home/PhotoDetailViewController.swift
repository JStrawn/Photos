//
//  PhotoDetailView.swift
//  JStrawn_Photos
//
//  Created by Jay Strawn on 7/3/18.
//  Copyright © 2018 Jay Strawn. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
  
  // MARK: - Injections
  var currentPhoto: Photo!

  // MARK: - Outlets
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.loadImageUsingCacheWithURLString(urlString: currentPhoto.url)
    titleLabel.text = currentPhoto.title
  }
}
