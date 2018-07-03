//
//  HomeViewController.swift
//  JStrawn_Photos
//
//  Created by Jay Strawn on 6/26/18.
//  Copyright © 2018 Jay Strawn. All rights reserved.
//

import UIKit
import Lottie
import Reachability

class HomeViewController: UIViewController {
  
  // MARK: - Injections
  private var images = [UIImage]()
  private var loadingAnimation: LOTAnimationView?
  private var networkingSharedInstance = Networking()
  private var hasData: Bool?
  private let refreshControl = UIRefreshControl()
  
  // MARK: - Outlets
  @IBOutlet weak var photoCollectionView: UICollectionView!
  @IBOutlet weak var noNetworkConnectionLabel: UILabel!
  @IBOutlet weak var tryAgainButton: UIButton!
  
  @IBAction func didTapTryAgainButton(_ sender: UIButton) {
    loadPhotos()
  }
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    loadPhotos()
    reloadTableViewAfterNetworkCall()
    setUpCollectionViewRefresh()
  }
  
  func showLoadingIndicator() {
    loadingAnimation = LOTAnimationView(name: "simple_loader")
    loadingAnimation!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    loadingAnimation!.contentMode = .scaleAspectFill
    loadingAnimation!.frame = view.bounds
    view.addSubview(loadingAnimation!)
    
    loadingAnimation!.loopAnimation = true
    loadingAnimation!.play(fromProgress: 0, toProgress: 1.0, withCompletion: nil)
  }
  
  func removeLoadingIndicator() {
    loadingAnimation?.removeFromSuperview()
  }
  
  func loadPhotos() {
    let reachability = Reachability()!
    
    reachability.whenReachable = { reachability in
      self.showLoadingIndicator()
      self.networkingSharedInstance.getPhotosInformation()
      self.noNetworkConnectionLabel.isHidden = true
      self.tryAgainButton.isHidden = true
    }
    //uuygghhh
    reachability.whenUnreachable = { _ in
      if self.photoCollectionView != nil {
      self.noNetworkConnectionLabel.isHidden = false
      self.tryAgainButton.isHidden = false
      }
      self.removeLoadingIndicator()
      self.refreshControl.endRefreshing()
    }
    
    do {
      try reachability.startNotifier()
    } catch {
      print("Unable to start notifier")
    }
  }
}

// MARK: - UICollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return networkingSharedInstance.photos.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCell
    let currentPhoto = networkingSharedInstance.photos[indexPath.row]
    cell.imageView.loadImageUsingCacheWithURLString(urlString: currentPhoto.thumbnailUrl)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "PhotoDetailViewController") as! PhotoDetailViewController
    vc.currentPhoto = networkingSharedInstance.photos[indexPath.row]
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width / 3, height:  view.frame.width / 3)
  }
  
  func setUpCollectionViewRefresh() {
    if #available(iOS 10.0, *) {
      photoCollectionView.refreshControl = refreshControl
    } else {
      photoCollectionView.addSubview(refreshControl)
    }
    refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
  }
  
  @objc private func refreshWeatherData(_ sender: Any) {
    loadPhotos()
  }
}

// MARK: - ReloadCollectionViewDelegate
extension HomeViewController: ReloadCollectionViewDelegate {
  func didGetResult(_ success: Bool) {
    self.hasData = success
    DispatchQueue.main.async {
      self.photoCollectionView.reloadData()
      self.removeLoadingIndicator()
      self.refreshControl.endRefreshing()
    }
  }
  
  func reloadTableViewAfterNetworkCall() {
    networkingSharedInstance.delegate = self
  }
}

