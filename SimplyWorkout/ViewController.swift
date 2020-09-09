//
//  ViewController.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 11/07/2020.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit
import FSCalendar
import CoreData

enum Section {
    case main
}

class ViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UIGestureRecognizerDelegate, NSFetchedResultsControllerDelegate, FSCalendarDelegateAppearance {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var plusBtn: UIButton!
    
    @IBAction func plusBtnTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "AddRecord") as! AddViewController
        self.present(vc, animated: true, completion: nil)
        vc.addDataDelegate = self
    }
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    
    /// CoreData Stack
    var context = PersistentStorage.shared.persistentContainer.viewContext
    var fetchedResultsCtrl: NSFetchedResultsController<WorkoutDataCD>!
    var selectedDate: String?
    var numberOfObjectsInCurrentSection: Int?
    
    /// Make the navigation bar hidden.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedDate = dateFormatter.string(from: self.calendar.today!)
        setupFetchedResultsData()
        
        self.calendar.select(Date())
        self.calendar.scope = .month
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        
        preSetUp()
        plusBtn.customPlusButton()
        tableView.tableFooterView = UIView()
  
    }
   
    func setupFetchedResultsData() {
        if fetchedResultsCtrl == nil {
            let request = WorkoutDataCD.createFetchRequest()
            let sort = NSSortDescriptor(key: "created", ascending: true)
            request.sortDescriptors = [sort]
            
            fetchedResultsCtrl = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "toEventDate.activityDate", cacheName: nil)
            
            fetchedResultsCtrl.delegate = self
        }
        
        let predicate = NSPredicate(format: "toEventDate.activityDate CONTAINS %@", selectedDate!)
        fetchedResultsCtrl.fetchRequest.predicate = predicate
        
        do {
            try fetchedResultsCtrl.performFetch()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.calendar.layoutIfNeeded()
            }
        }
        catch {
            print("Fetch failed")
        }
    }
    
    func preSetUp() {
        Theme.calendar = calendar
        self.view.backgroundColor = Theme.currentTheme.backgroundColor
        
        calendar.backgroundColor = Theme.currentTheme.backgroundColor
        
        viewContainer.addBorder(1)
        viewContainer.backgroundColor = Theme.currentTheme.backgroundColor
        
        tableView.backgroundColor = Theme.currentTheme.backgroundColor
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.viewContainer)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            @unknown default:
                fatalError()
            }
        }
        return shouldBegin
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        //        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        if calendar.gregorian.isDateInToday(date) == false {
            calendar.appearance.titleTodayColor = UIColor.applyColor(AssetsColor.vivacious)
        }
        /// if user selects the date, the data is shown on the table view. the data can be multiple.
        selectedDate = dateFormatter.string(from: date)
        setupFetchedResultsData()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        let dateString = dateFormatter.string(from: date)
      
        return 0
        
    }
}

// MARK: - AddData Delegate
extension ViewController: AddData {
    
    func addWorkoutData(activity: String, detail: String, effortType: String, duration: String, colorType: String, location: String) {
        let userWorkout = WorkoutDataCD(context: context)
        userWorkout.activityName = activity
        userWorkout.detail = detail
        userWorkout.effortType = effortType
        userWorkout.duration = duration
        userWorkout.colorTag = colorType
        userWorkout.created = Date()
        userWorkout.location = location
        
        let eventDate = EventDateCD(context: userWorkout.managedObjectContext!)
        eventDate.activityDate = dateFormatter.string(from: calendar.selectedDate!)
        eventDate.addToToWorkoutData(userWorkout)
        
        /// save the data
        do {
            try self.context.save()
        }
        catch {
        }
        
        /// Re-Fetch the data
        setupFetchedResultsData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsCtrl.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsCtrl.sections![section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsCtrl.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath) as! WorkoutTableViewCell
        let workoutData = fetchedResultsCtrl.object(at: indexPath)
        cell.workoutData = workoutData
        cell.backgroundColor = Theme.currentTheme.backgroundColor
        cell.selectionStyle = .none
        
        /// get an estimation of the height of the cell base on the detailLabel.text
        let detailLabelSize = CGSize(width: 289, height: 1000)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        let estimatedFrame = NSString(string: workoutData.detail!).boundingRect(with: detailLabelSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        //print(estimatedFrame.height)
        
        if estimatedFrame.height < 34 {
            tableView.rowHeight = 96
        }
        else {
            tableView.rowHeight = estimatedFrame.height + 60
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// TO DO: update the selected Data
        //        if let vc = storyboard?.instantiateViewController(withIdentifier: "") as? AddViewController {
        //            vc.
        //
      
        print("selected")
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completion) in
            let workoutData = self.fetchedResultsCtrl.object(at: indexPath)
            
            let section = self.fetchedResultsCtrl.sections![indexPath.section]
            self.numberOfObjectsInCurrentSection = section.numberOfObjects
            
            self.context.delete(workoutData)
          
            /// save the data
            do {
                try self.context.save()
            }
            catch {
            }
            completion(true)
            
        }
        
        deleteAction.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.beginUpdates()
            
            if numberOfObjectsInCurrentSection! > 1 {
                tableView.deleteRows(at: [indexPath!], with: .automatic)
            } else {
                let indexSet = NSMutableIndexSet()
                indexSet.add(indexPath!.section)
                tableView.deleteSections(indexSet as IndexSet, with: .fade)
            }
            
            tableView.endUpdates()

        default:
            break
        }
    }
}

extension Sequence where Element: Hashable {
    var frequency: [Element: Int] { reduce(into: [:]) { $0[$1, default: 0] += 1 } }
    func frequency(of element: Element) -> Int {
        return frequency[element] ?? 0
    }
}





