//
//  EventsTableViewCell.swift
//  BSU4U
//
//  Created by Alexey Meleshkevich on 02.04.2020.
//  Copyright © 2020 Li. All rights reserved.
//

import Foundation
import UIKit

class EventsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var eventTopic: UILabel!
}
