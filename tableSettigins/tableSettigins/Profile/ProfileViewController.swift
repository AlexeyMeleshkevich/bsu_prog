//
//  ProfileViewController.swift
//  BSU
//
//  Created by Alexey Meleshkevich on 26/11/2019.
//  Copyright © 2019 Alexey Meleshkevich. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var profile = Profile()  {
        didSet {
            DispatchQueue.main.async {
                self.nameLabel.text = "\(self.profile.surname) \(self.profile.name)  \(self.profile.fathername)"
                self.avatar.image = self.profile.getImage()
                let pageViewController = self.children[0] as! PageViewController
                pageViewController.profile = self.profile
                pageViewController.nextPageWithIndex(index: 0)
            }
        }
    }
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var segment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatar.layer.cornerRadius = avatar.frame.height / 2
        let api = ApiRequest(endpoint: "api/get-private-profile/")
        api.getPrivateProfile { (result) in
            switch result {
            case.failure(let error) : print(error)
            case.success(let profile) :
                self.profile = profile
            }
        }
    }
    
    
    @IBAction func changeTableView(_ sender: UISegmentedControl) {
        let pageViewController = self.children[0] as! PageViewController
        pageViewController.nextPageWithIndex(index: sender.selectedSegmentIndex)
    }
}
