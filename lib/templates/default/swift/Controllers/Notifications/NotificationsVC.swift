//
//  NotificationsVC.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit
import SwiftDate
import Kingfisher
import PMAlertController

class NotificationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - Outlets
    
    @IBOutlet var gradientView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backButton: UIButton!
    
    // MARK: - Properties
    
    let homeStoryboard = UIStoryboard(name: "Home", bundle: Bundle.main)
    
    var notifications = [Notif]()
    
    var selectedNotification: Notif?
    
    var delegate: NotificationReadProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = true
        self.tableView.isUserInteractionEnabled = true
        
        self.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.gradientView.applyGradient(withColours: [Colors.firstGradientColor, Colors.thirdGradientColor], locations: [0, 0.5])
    }
    
    private func setup() {
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        let origImage = UIImage(named: "Back")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        self.backButton.setImage(tintedImage, for: .normal)
        self.backButton.tintColor = UIColor(red: 107.0/255.0, green: 255.0/255.0, blue: 192.0/255.0, alpha: 1)
    }
    
    
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController{
            delegate?.setAsRead(value: true)
        }
    }
    
    // MARK: - Table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if notifications.count > 0 {
            self.hideNoNotificationsView()
            return 1
        }
        self.setNoNotificationsView()
        return 0
        
    }
    
    func setNoNotificationsView(){
        let emptyTableLabelViewNib = UINib(nibName: "NoNotificationsView", bundle: nil)
        let emptyTableLabelView = emptyTableLabelViewNib.instantiate(withOwner: nil, options: nil)[0] as! NoNotificationView
        emptyTableLabelView.tag = 100
        self.tableView.separatorStyle = .none
        self.tableView.backgroundView = emptyTableLabelView
    }
    
    func hideNoNotificationsView(){
        self.tableView.separatorStyle = .singleLine
        if let viewWithTag = self.tableView.viewWithTag(100) {
            viewWithTag.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        
        let notification = self.notifications[indexPath.row]

        cell.notificationText.text = notification.body
        
        if !notification.read{
            cell.newNotificationView.isHidden = false
        }

        let region = Region.Local()
        let dateB = DateInRegion(absoluteDate: notification.createdDate as Date, in: region)
        let (colloquial, _) = try! dateB.colloquialSinceNow()
        cell.notificationDate.text = colloquial
        switch notification.notifType{
            case .broadcast:
                break
            case .generic:
                break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.isUserInteractionEnabled = false
        
        let selectedNotif = self.notifications[indexPath.row]
        
        self.selectedNotification = selectedNotif
        
        switch selectedNotif.notifType {
        case .broadcast:
            self.tableView.isUserInteractionEnabled = true
            break
        case .generic:
            self.tableView.isUserInteractionEnabled = true
            //Perform segue to detail
            break
        default:
            self.tableView.isUserInteractionEnabled = true
            break
        }
    }

}

protocol NotificationReadProtocol {
    func setAsRead(value: Bool)
}

