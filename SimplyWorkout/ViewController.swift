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

class ViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UIGestureRecognizerDelegate, NSFetchedResultsControllerDelegate {
    
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
    
    /// Collecting User's Workout Data
    var workoutData = [WorkoutData]()
    var checkBorder: Bool = true
    private var diffableDataSource: UITableViewDiffableDataSource<Section, WorkoutDataCD>!
    
    /// CoreData Stack
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedResultsCtrl: NSFetchedResultsController<WorkoutDataCD>!
    
    /// Make the navigation bar hidden.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar.select(Date())
        self.calendar.scope = .month
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)

        configureDataSource()
        preSetUp()
        plusBtn.customPlusButton()
        tableView.tableFooterView = UIView()
        
        setupFetchedResultsData()
    }
    
    func setupFetchedResultsData() {
        let request = WorkoutDataCD.createFetchRequest()
        let sort = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [sort]
        
        fetchedResultsCtrl = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "toEventDate.activityDate", cacheName: nil)
        
        fetchedResultsCtrl.delegate = self
        
        do {
            try fetchedResultsCtrl.performFetch()
            
            DispatchQueue.main.async {
                self.updateSnapshot()
                self.tableView.reloadData()
            }
        }
        catch {
            print("Fetch failed")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapshot()
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
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        if calendar.gregorian.isDateInToday(date) == false {
            calendar.appearance.titleTodayColor = UIColor.applyColor(AssetsColor.vivacious)
        }
        /// TO DO: if user selects the date, the data is shown on the table view. the data can be multiple.
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

// MARK: - UITableViewDiffable DataSource
class WorkoutDataSource: UITableViewDiffableDataSource<Section, WorkoutDataCD> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension ViewController {
    
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, WorkoutDataCD>()
        snapshot.appendSections([.main])
        snapshot.appendItems(fetchedResultsCtrl.fetchedObjects ?? [], toSection: .main)
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }

    func configureDataSource() {
        diffableDataSource = WorkoutDataSource(tableView: tableView) { (tableView, indexPath, workoutData) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath) as! WorkoutTableViewCell
            cell.workoutData = workoutData
            cell.backgroundColor = Theme.currentTheme.backgroundColor
            cell.selectionStyle = .none
            
            /// get an estimation of the height of the cell base on the detailLabel.text
            let detailLabelSize = CGSize(width: 289, height: 1000)
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
            let estimatedFrame = NSString(string: workoutData.detail!).boundingRect(with: detailLabelSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            //print(estimatedFrame.height)
            
            if estimatedFrame.height < 34 {
                if estimatedFrame.height < 18 {
                    tableView.rowHeight = 96
                    let verticalSpace = NSLayoutConstraint(item: cell.dateLabel!, attribute: .top, relatedBy: .equal, toItem: cell.activityDetail, attribute: .bottom, multiplier: 1, constant: 29.5)
                    cell.addConstraint(verticalSpace)
                }
                else if estimatedFrame.height > 18 && estimatedFrame.height < 34 {
                    tableView.rowHeight = 96
                    let verticalSpace = NSLayoutConstraint(item: cell.dateLabel!, attribute: .top, relatedBy: .equal, toItem: cell.activityDetail, attribute: .bottom, multiplier: 1, constant: 13)
                    cell.addConstraint(verticalSpace)
                }
            }
            else {
                tableView.rowHeight = estimatedFrame.height + 60
                let verticalSpace = NSLayoutConstraint(item: cell.dateLabel!, attribute: .top, relatedBy: .equal, toItem: cell.activityDetail, attribute: .bottom, multiplier: 1, constant: 10)
                cell.addConstraint(verticalSpace)
            }
            
            return cell
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completion) in
            /// figure out the data to delete
            guard let data = self.diffableDataSource.itemIdentifier(for: indexPath) else { return }
            self.context.delete(data)
            /// save the data
            do {
                try self.context.save()
            }
            catch {
                
            }
            
            /// Re-Fetch the data
            self.setupFetchedResultsData()
            //print("the deleted index is \(indexPath.row)"
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected!")
    }
    
    
}






