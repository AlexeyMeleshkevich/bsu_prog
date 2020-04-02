//
//  CalendarViewController.swift
//  BSU
//
//  Created by Alexey Meleshkevich on 18/11/2019.
//  Copyright © 2019 Alexey Meleshkevich. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
    
    let noLessonsLabel: UILabel = {
        let label = UILabel()
        label.text = "Сегодня занятий нет"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var lessons = [Lesson]() {
        didSet {
            DispatchQueue.main.async {
                if self.lessons.count != 0 {
                    self.scheduleView.reloadData()
                }
            }
        }
    }
    
    var informationState: String = String() {
        didSet(type) {
            switch type {
            case "education":
                self.setInformationItem(with: type)
            case "bolt":
                self.setInformationItem(with: type)
            default:
                break
            }
        }
    }
    
    public let IDForCalendar = "C1"
    
    @IBOutlet weak var Calendar: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scheduleView: UITableView!
    @IBOutlet weak var informationTypeItem: UIBarButtonItem!
    @IBOutlet weak var eventsView: UITableView!
    
    // MARK: Date for calendar
    let Months = ["Январь",
                  "Февраль",
                  "Март",
                  "Апрель",
                  "Май",
                  "Июнь",
                  "Июль",
                  "Август",
                  "Сентябрь",
                  "Октябрь",
                  "Ноябрь",
                  "Декабрь"]
    
    let stringMonths = ["Января",
    "Февраля",
    "Марта",
    "Апреля",
    "Мая",
    "Июня",
    "Июля",
    "Августа",
    "Сентября",
    "Октября",
    "Ноября",
    "Декабря"]
    
    var DaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    // Calendar logic
    var numberOfEmptyBoxes = 2     // The number of empty cells at the start of the current month
    var nextNumberOfEmptyBox = Int()
    var previosNumberOfEmptyBox = Int()
    var direction = 0                   // == 0 if current, == 1 if future, == -1 if in past
    var positionIndex = 2
    var currentMonth = String()
    let educationImage = UIImage(named: "education")
    let boltImage = UIImage(systemName: "bolt")
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.informationState = "bolt"
        eventsView.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getLessons()
        scheduleView.reloadData()
        currentMonth = Months[month]
        dateLabel.text = "\(currentMonth) " + "\(year)"
        self.eventsView.backgroundColor = UIColor.clear
        setTableView()
    }
    
    func setTableView() {
        eventsView.separatorStyle = .none
//        eventsView.backgroundColor = UIColor.systemGray5
        setHeaderLabel()
    }

    func setHeaderLabel() {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: Int(self.eventsView.frame.width), height: 36))
        let headerLabel = UILabel(frame: header.bounds)
        header.backgroundColor = UIColor.clear
        headerLabel.textAlignment = .center
        headerLabel.textColor = .lightGray
        headerLabel.text = "\(day), \(stringMonths[month])"
        header.addSubview(headerLabel)
        
        eventsView.tableHeaderView = header
    }
    
    @IBAction func informationBarItemPressed(_ sender: Any) {
        
        switch informationState {
        case "bolt":
            self.informationState = "education"
            self.informationTypeItem.image = educationImage
            flipEducation()
        case "education":
            self.informationState = "bolt"
            self.informationTypeItem.image = boltImage
            flipBolt()
        default:
            break
        }
    }
    
    @IBAction func back(_ sender: Any) {
        switch currentMonth {
        case "Январь":
            month = 11
            year -= 1
            direction = -1
            
            if year % 4 == 0 {
                DaysInMonth[1] = 29
            } else {
                DaysInMonth[1] = 28
            }
            
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            dateLabel.text = "\(currentMonth) " + "\(year)"
            Calendar.reloadData()
        default:
            month -= 1
            direction = -1
            
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            dateLabel.text = "\(currentMonth) " + "\(year)"
            Calendar.reloadData()
        }
        if current_month_i == month && current_year_i == year {
            day = current_day_i
        } else {
            day = -1
        }
    }
    
    
    @IBAction func next(_ sender: Any) {
        if year % 4 == 0 {
            DaysInMonth[1] = 29
        }
        else {
            DaysInMonth[1] = 28
        }
        switch currentMonth {
        case "Декабрь":
            month = 0
            year += 1
            direction = 1
            
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            dateLabel.text = "\(currentMonth) " + "\(year)"
            Calendar.reloadData()
        default:
            direction = 1
            
            GetStartDateDayPosition()
            
            month += 1
            
            currentMonth = Months[month]
            dateLabel.text = "\(currentMonth) " + "\(year)"
            Calendar.reloadData()
        }
        if current_month_i == month && current_year_i == year {
            day = current_day_i
        } else {
            day = -1
        }
        
    }
    
    func GetStartDateDayPosition() {
        switch direction {
        case 0:
            switch day {
            case 1...7:
                numberOfEmptyBoxes = weekday - day
            case 8...14:
                numberOfEmptyBoxes = weekday - day - 7
            case 15...21:
                numberOfEmptyBoxes = weekday - day - 14
            case 22...28:
                numberOfEmptyBoxes = weekday - day - 21
            case 29...31:
                numberOfEmptyBoxes = weekday - day - 28
            default:
                break
            }
            positionIndex = numberOfEmptyBoxes
            
        case 1...:
            nextNumberOfEmptyBox = (positionIndex + DaysInMonth[month])%7
            positionIndex = nextNumberOfEmptyBox
            
        case -1:
            previosNumberOfEmptyBox = (7 - (DaysInMonth[month] - positionIndex) % 7)
            if previosNumberOfEmptyBox == 7 {
                previosNumberOfEmptyBox = 0
            }
            positionIndex = previosNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    func setInformationItem(with state: String) {
        switch state {
        case "education":
            self.informationTypeItem.image = educationImage
        case "bolt":
            self.informationTypeItem.image = boltImage
        default:
            break
        }
    }
    
    func flipEducation() {
        let transOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        
        UIView.transition(with: scheduleView, duration: 1.0, options: transOptions, animations: {
            self.scheduleView.isHidden = true
        }, completion: nil)
        
        UIView.transition(with: eventsView, duration: 1.0, options: transOptions, animations: {
            self.eventsView.isHidden = false
        }, completion: nil)
    }
    
    func flipBolt() {
        let transOptions: UIView.AnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
        
        UIView.transition(with: scheduleView, duration: 1.0, options: transOptions, animations: {
            self.scheduleView.isHidden = false
        }, completion: nil)
        
        UIView.transition(with: eventsView, duration: 1.0, options: transOptions, animations: {
            self.eventsView.isHidden = true
        }, completion: nil)
    }
}



