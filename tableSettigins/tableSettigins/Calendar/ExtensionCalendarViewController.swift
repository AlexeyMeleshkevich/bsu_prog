//
//  ExtensionCalendarViewController.swift
//  tableSettigins
//
//  Created by Li on 12/21/19.
//  Copyright © 2019 Li. All rights reserved.
//

import UIKit

extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: lessonsView(UITableView) protocols methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
        case eventsView:
            return 3
        case scheduleView:
             
                   if lessons.count == 0 {
                       self.scheduleView.separatorStyle = .none
                       scheduleView.addSubview(self.noLessonsLabel)
                       self.noLessonsLabel.isHidden = false
                       self.scheduleView.isScrollEnabled = false

                       setLabelLayout()
                       return 0
                   } else {
                       self.scheduleView.isScrollEnabled = true
                       self.scheduleView.separatorStyle = .singleLine
                       self.noLessonsLabel.isHidden = true
                       return lessons.count
                   }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case eventsView:
            return 100
        case scheduleView:
            return 150
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case eventsView:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.eventsCellID, for: indexPath) as! EventsTableViewCell
            
            let topics = ["Пьем пиво","Выпиваем Пиво","Допиваем пиво"]
            let date = ["12:00","15:00","22:00"]
            cell.eventName.text = "\(topics[indexPath.row])"
            cell.eventDate.text = "\(date[indexPath.row])"
            cell.eventDescription.isEditable = false
            cell.eventDescription.isUserInteractionEnabled = false
//            cell.layer.cornerRadius = 20
//            cell.layer.shadowOffset = CGSize(width: 0, height: 5)
//            cell.layer.shadowOpacity = 0.3
//            cell.layer.shadowRadius = 2
            
            return cell
        case scheduleView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "C2", for: indexPath) as! ScheduleTableViewCell
            
            cell.lessonTime.text = lessons[indexPath.row].time_start!
            cell.lessonType.text = lessons[indexPath.row].time_end!
            cell.lessonName.text = lessons[indexPath.row].subject!
            cell.lessonLocation.text = lessons[indexPath.row].getParam()
            cell.teacherName.text = "\(lessons[indexPath.row].surname!) \(lessons[indexPath.row].name!) \(lessons[indexPath.row].fathername!)"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func setLabelLayout() {
        self.noLessonsLabel.centerYAnchor.constraint(equalTo: self.scheduleView.centerYAnchor, constant: 0).isActive = true
        self.noLessonsLabel.centerXAnchor.constraint(equalTo: self.scheduleView.centerXAnchor).isActive = true
    }
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: Calendar(UICollectionView) protocols methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch direction {
        case 0:
            return DaysInMonth[month] + numberOfEmptyBoxes
        case 1...:
            return DaysInMonth[month] + nextNumberOfEmptyBox
        case -1:
            return DaysInMonth[month] + previosNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        day = indexPath.row + 1
        collectionView.reloadData()
        getLessons()
        scheduleView.reloadData()
    }
    
    func getLessons() {
        var dayString = String()
        switch direction {
        case 0:
            dayString = "\(day - numberOfEmptyBoxes)"
        case 1:
            dayString = "\(day - nextNumberOfEmptyBox)"
        case -1:
            dayString = "\(day - previosNumberOfEmptyBox)"
        default:
            fatalError()
        }
        
        let api = ApiRequest(endpoint: "api/get-shedule-day-list?date=\(year)-\(month + 1)-\(dayString)")
        print("\(year)-\(month + 1)-\(dayString)")
        api.getLesson { (result) in
            switch result {
            case.failure(let error) :
                print(error)
                self.lessons = [Lesson]()
            case.success(let lessons) :
                self.lessons = lessons
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IDForCalendar, for: indexPath) as! DateCollectionViewCell
        cell.backgroundColor = UIColor.clear
        cell.cellDateLabel.textColor = UIColor.black
        
        if cell.isHidden {
            cell.isHidden = false
        }
        
        switch direction {
        case 0:
            cell.cellDateLabel.text = "\(indexPath.row + 1 - numberOfEmptyBoxes)"
        case 1:
            cell.cellDateLabel.text = "\(indexPath.row + 1 - nextNumberOfEmptyBox)"
        case -1:
            cell.cellDateLabel.text = "\(indexPath.row + 1 - previosNumberOfEmptyBox)"
        default:
            fatalError()
        }
        
        if Int(cell.cellDateLabel.text!)! < 1 {
            cell.isHidden = true
        }
        
        switch indexPath.row {
        case 5,6,12,13,19,20,26,27,33,34:
            if Int(cell.cellDateLabel.text!)! > 0 {
                cell.cellDateLabel.textColor = UIColor.lightGray
            }
        default:
            break
        }
        
        if  indexPath.row + 1 == day{
            cell.backgroundColor = Constants.customBlue
            cell.layer.cornerRadius = 24.0
            cell.cellDateLabel.textColor = UIColor.white
        }
        return cell
    }
    
}

//extension CalendarViewController: UITableViewDataSource {
//
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
//    {
//        let verticalPadding: CGFloat = 15
//        let maskLayer = CALayer()
//        cell.backgroundColor = UIColor.white
//        cell.isUserInteractionEnabled = false
//        maskLayer.cornerRadius = 15
//        cell.clipsToBounds = true
//        maskLayer.backgroundColor = UIColor.black.cgColor
//        maskLayer.frame = CGRect(x: cell.bounds.origin.x + 20, y: cell.bounds.origin.y, width: cell.bounds.width - 40, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding)
//        cell.layer.mask = maskLayer
//    }
//}
//
//extension CalendarViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    }
//}

