//
//  HitchhikerHomeViewController.swift
//  iOS_Final_Project
//
//  Created by Ege Melis Ayanoğlu on 5.12.2019.
//  Copyright © 2019 Bogo. All rights reserved.
//

import UIKit

extension HitchhikerHomeViewController: HitchhikerHomeDataSourceDelegate {
    func showAlertMsg(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func setId() {
        
    }
    
    func hitchhikerFeedListLoaded() {
        self.hitchhikerHomeTableView.reloadData()
    }
}
   
class HitchhikerHomeViewController: UIViewController {
    @IBOutlet weak var hitchhikerHomeTableView: UITableView!
    
    let hitchhikerHomeDataSource = HitchhikerHomeDataSource()
    let hitchhikerHomeHelper = HitchhikerHomeHelper()
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hitchhikerHomeTableView.dataSource = self
        hitchhikerHomeTableView.delegate = self
        hitchhikerHomeDataSource.delegate=self
        
        title = "Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(profileButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "My Requests", style: .plain, target: self, action: #selector(requestsButtonTapped))
        
        
        //refreshControl.addTarget(hitchhikerHomeTableView, action: #selector(reloadData), for: .valueChanged)
        refreshControl.addTarget(self, action:  #selector(reloadData), for: .valueChanged)
        hitchhikerHomeTableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = UserDefaults.standard
        if let username = userDefaults.string(forKey: "username") {
            print("Username: ", username)
            hitchhikerHomeDataSource.getUser(username: username)
            hitchhikerHomeDataSource.getPlannedTrips(hitchhikerName: username)
        }
    }
    
    @objc func profileButtonTapped() {
        performSegue(withIdentifier: "toHitchhikerProfile", sender: nil)
    }
    
    @objc func requestsButtonTapped() {
        performSegue(withIdentifier: "toHitchhikerRequests", sender: nil)
    }
    
    @objc func reloadData() {
        let userDefaults = UserDefaults.standard
        if let username = userDefaults.string(forKey: "username") {
            hitchhikerHomeDataSource.getPlannedTrips(hitchhikerName: username)
        }
        hitchhikerHomeTableView.refreshControl?.endRefreshing()
        hitchhikerHomeTableView.reloadData()
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHitchhikerProfile" {
            print("prepare id: ", hitchhikerHomeDataSource.hitchhiker?.id)
            let destinationVc = segue.destination as! HitchhikerProfileViewController
            destinationVc.hitchhikerProfileDataSource.hitchhiker = hitchhikerHomeDataSource.hitchhiker
        }
        
        if segue.identifier == "toOtherProfile" {
            let destinationVc = segue.destination as! HitchhikerOtherProfileViewController
            destinationVc.hitchhikerOtherProfileDataSource.otherUsername = hitchhikerHomeHelper.selectedUsername ?? ""
        }
        
        if segue.identifier == "toHitchhikerRequests" {
            let destinationVc = segue.destination as! HitchhikerTripRequestsViewController
            destinationVc.hitchhikerTripRequestsDataSource.hitchhiker = hitchhikerHomeDataSource.hitchhiker
        }
    }
}

extension HitchhikerHomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hitchhikerHomeDataSource.feedArray.isEmpty {
            return 1
        }
        return hitchhikerHomeDataSource.feedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if hitchhikerHomeDataSource.feedArray.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
            cell.messageTextField.text = "No driver post a trip yet. Wait for apply one"
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HitchhikerHomeCell", for: indexPath) as! HitchhikerHomeTableViewCell
        let feed = hitchhikerHomeDataSource.feedArray[indexPath.row]
        let ratingImageNamesArray = hitchhikerHomeHelper.getRatingImageArray(rating: feed.rating)
        
        cell.starOneImageView.image = UIImage(systemName: ratingImageNamesArray[0])
        cell.starTwoImageView.image = UIImage(systemName: ratingImageNamesArray[1])
        cell.starThreeImageView.image = UIImage(systemName: ratingImageNamesArray[2])
        cell.starFourImageView.image = UIImage(systemName: ratingImageNamesArray[3])
        cell.starFiveImageView.image = UIImage(systemName: ratingImageNamesArray[4])
        
        cell.usernameLabel.text = feed.driverUserName
        cell.carModelLabel.text = feed.carModel
        cell.availableSeatsLabel.text = "\(feed.availableSeatNumber)"
        cell.fromLabel.text = feed.from
        cell.toLabel.text = feed.to
        cell.minDepartureTimeLabel.text = feed.startTime.UTCToLocal()//.convertUtcToDisplay()
        cell.maxDepartureTimeLabel.text = feed.endTime.UTCToLocal()//.convertUtcToDisplay()
        let dataDecoded : Data = Data(base64Encoded: feed.image, options: .ignoreUnknownCharacters)!
        cell.profileImageView.image = UIImage(data: dataDecoded)!
        
        /*  if let profileImage = feed.profileImage {
            cell.profileImageView.image = profileImage
        }
 */
        return cell
    }
}

extension HitchhikerHomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    if hitchhikerHomeDataSource.feedArray.isEmpty {
        return nil
    }
       let tripRequestAction = self.hitchhikerHomeDataSource.contextualTripRequestAction(forRowAtIndexPath: indexPath)
        let swipeConfig = UISwipeActionsConfiguration(actions: [tripRequestAction])
        return swipeConfig
 
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !hitchhikerHomeDataSource.feedArray.isEmpty {
        let feed = hitchhikerHomeDataSource.feedArray[indexPath.row]
        hitchhikerHomeHelper.selectedUsername = feed.driverUserName
        performSegue(withIdentifier: "toOtherProfile", sender: nil)
            }
    }
}
