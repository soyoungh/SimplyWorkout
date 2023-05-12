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
import GoogleMobileAds
import SwiftyStoreKit

enum Section {
    case main
}

class ViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UIGestureRecognizerDelegate, NSFetchedResultsControllerDelegate, FSCalendarDelegateAppearance {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var plusBtnConstraint: NSLayoutConstraint!
    @IBOutlet weak var configBtn: UIButton!
    @IBOutlet weak var reportBtn: UIButton!
    var configIcon: UIImage!
    
    var bannerView: GADBannerView!
    let adUnitID = "ca-app-pub-5585665050991980/9398800141"
    let testID = "ca-app-pub-3940256099942544/2934735716"
    
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
    var checkBorder: Bool = true
    private var diffableDataSource: UITableViewDiffableDataSource<Section, WorkoutDataCD>!
    
    /// CoreData Stack
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedResultsCtrl: NSFetchedResultsController<WorkoutDataCD>!
    var selectedDate: String?
    var selectedDataArray = [WorkoutDataCD]()
    
    let IAPPurchaseIDs = [["com.soyoungHyun.SimplyWorkout.ncRemoveAds"]]
    let sharedSecret = "c620d1374ee34cd88444245fa7f27e2d"
    
    /// Localization Labels
    var vo_gym = NSLocalizedString("v_Gym", comment: "vc_locationLabel")
    var vo_home = NSLocalizedString("v_Home", comment: "vc_locationLabel")
    var vo_outside = NSLocalizedString("v_Outside", comment: "vc_locationLabel")
    
    var vo_veryLight = NSLocalizedString("v_Very Light", comment: "vc_effortLabel")
    var vo_light = NSLocalizedString("v_Light", comment: "vc_effortLabel")
    var vo_moderate = NSLocalizedString("v_Moderate", comment: "vc_effortLabel")
    var vo_vigorous = NSLocalizedString("v_Vigorous", comment: "vc_effortLabel")
    var vo_hard = NSLocalizedString("v_Hard", comment: "vc_effortLabel")
    var vo_max = NSLocalizedString("v_Max", comment: "vc_effortLabel")
    
    var vo_h = NSLocalizedString("v_h", comment: "vc_h")
    var vo_m = NSLocalizedString("v_m", comment: "vc_m")
    var vo_min = NSLocalizedString("v_min", comment: "vc_min")
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if Theme.currentTheme.accentColor == UIColor.applyColor(AssetsColor.paleBrown) {
            return .darkContent
        }
        else {
            return .lightContent
        }
    }
    
    /// Make the navigation bar hidden.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.rowHeight = UITableView.automaticDimension
        themeChanged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar.select(Date())
        self.calendar.scope = .month
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        
        configureDataSource()
        preSetUp()
        themeChanged()
        tableView.tableFooterView = UIView()
        setupFetchedResultsData()
        
        plusBtnConstraint.constant = 65
        
        if !UserDefaults.standard.bool(forKey: "removeAds") {
            // show ads
            self.reportBtn.alpha = 0.5
            addBanner(with: testID)
        }
        else {
            // no ads
            self.reportBtn.alpha = 1.0
        }
        
    }
   
    func addBanner(with id: String) {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = id
        addBannerViewToView(bannerView)
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
    }
    
    func setupFetchedResultsData() {
        let request = WorkoutDataCD.createFetchRequest()
        let sort = NSSortDescriptor(key: "created", ascending: true)
        let predicate = NSPredicate(format: "toEventDate.activityDate CONTAINS %@", selectedDate!)
        request.predicate = predicate
        request.sortDescriptors = [sort]
        
        fetchedResultsCtrl = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "toEventDate.activityDate", cacheName: nil)
        
        fetchedResultsCtrl.delegate = self
        
        do {
            try fetchedResultsCtrl.performFetch()
            selectedDataArray.removeAll()
            DispatchQueue.main.async {
                self.updateSnapshot()
                self.tableView.reloadData()
                self.calendar.layoutIfNeeded()
            }
        }
        catch {
            print("Fetch failed")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapshot()
        calendar.reloadData()
    }
    
    func preSetUp() {
        Theme.calendar = calendar
        self.selectedDate = dateFormatter.string(from: self.calendar.today!)
        viewContainer.addTopBorder(1, view: self.view)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.separatorColor = Theme.currentTheme.separatorColor
        
        configIcon = UIImage(named: "setting")
        let tempImage = configIcon.withRenderingMode(.alwaysTemplate)
        configBtn.setImage(tempImage, for: .normal)
        configBtn.addTarget(self, action: #selector(configTapped), for: .touchUpInside)
        
        reportBtn.addTarget(self, action: #selector(reportTapped), for: .touchUpInside)
    }
    
    @objc func reportTapped() {
        if self.reportBtn.alpha == 1.0 {
            let vc = storyboard?.instantiateViewController(identifier: "reportPage") as! MonthlyReportCtrl
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if self.reportBtn.alpha == 0.5 {
            let vc2 = storyboard?.instantiateViewController(identifier: "removeAds") as! IAPController
            self.present(vc2, animated: true)
        }
        
    }
    
    @objc func configTapped() {
        let vc = storyboard?.instantiateViewController(identifier: "settingPage") as! ConfigurationsController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func themeChanged() {
        
        self.view.backgroundColor = Theme.currentTheme.backgroundColor
        
        calendar.backgroundColor = Theme.currentTheme.backgroundColor
        calendar.appearance.headerTitleColor = Theme.currentTheme.headerTitleColor
        calendar.appearance.weekdayTextColor = Theme.currentTheme.weekdayTextColor
        calendar.appearance.titleDefaultColor = Theme.currentTheme.dateTextColor
        calendar.appearance.selectionColor = Theme.currentTheme.selectionColor
        
        viewContainer.backgroundColor = Theme.currentTheme.backgroundColor
        
        tableView.backgroundColor = Theme.currentTheme.backgroundColor
        
        plusBtn.customPlusButton()
        configBtn.tintColor = Theme.currentTheme.accentColor
        reportBtn.tintColor = Theme.currentTheme.accentColor
        
        tableView.reloadData()
        calendar.reloadData()
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints([NSLayoutConstraint(item: bannerView, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0), NSLayoutConstraint(item: bannerView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)])
    }
    
    func createAlert(alertTitle: String?, alertMessage: String?) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let Ok = UIAlertAction(title: NSLocalizedString("okBtn_monthlyReportAlart", comment: "ok Button_monthlyReportAlart"), style: .cancel) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(Ok)
        present(alert, animated: true, completion: nil)
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
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        if calendar.gregorian.isDateInToday(date) == false {
            calendar.appearance.titleTodayColor = Theme.currentTheme.titleTodayColor
        }
        /// if user selects the date, the data is shown on the table view. the data can be multiple.
        selectedDate = dateFormatter.string(from: date)
        setupFetchedResultsData()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        let dateString = dateFormatter.string(from: date)
        let reqeust = WorkoutDataCD.createFetchRequest()
        
        do {
            let dataResults = try context.fetch(reqeust)
            let count = dataResults.filter{ $0.toEventDate!.activityDate! == dateString }.count
            return count
        }
        catch let err {
            print(err)
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let dateString = dateFormatter.string(from: date)
        let reqeust = WorkoutDataCD.createFetchRequest()
        
        do {
            let dataResults = try context.fetch(reqeust)
            let key = dataResults.filter{ $0.toEventDate!.activityDate! == dateString }
            var colorArray = [UIColor]()
            for data in key {
                let colorName = data.colorTag!
                colorArray.append(UIColor(named: colorName)!)
            }
            return colorArray
        }
        catch let err {
            print(err)
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        let dateString = dateFormatter.string(from: date)
        let reqeust = WorkoutDataCD.createFetchRequest()
        
        do {
            let dataResults = try context.fetch(reqeust)
            let key = dataResults.filter{ $0.toEventDate!.activityDate! == dateString }
            var colorArray = [UIColor]()
            for data in key {
                let colorName = data.colorTag!
                colorArray.append(UIColor(named: colorName)!)
            }
            return colorArray
        }
        catch let err {
            print(err)
        }
        return nil
    }
}

// MARK: - AddData Delegate
extension ViewController: AddData {
    func addWorkoutData(activity: String, detail: String, effortType: String, duration: String, colorType: String, location: String, effortValue: Float) {
        
        if selectedDataArray.isEmpty == true {
            let userWorkout = WorkoutDataCD(context: context)
            userWorkout.activityName = activity
            userWorkout.detail = detail
            userWorkout.effortType = effortType
            userWorkout.duration = duration
            userWorkout.colorTag = colorType
            userWorkout.created = Date()
            userWorkout.location = location
            userWorkout.effortValue = effortValue
            
            let eventDate = EventDateCD(context: userWorkout.managedObjectContext!)
            eventDate.activityDate = dateFormatter.string(from: calendar.selectedDate!)
            eventDate.addToToWorkoutData(userWorkout)
        }
        else {
            for data in selectedDataArray {
                data.activityName = activity
                data.detail = detail
                data.effortType = effortType
                data.duration = duration
                data.colorTag = colorType
                data.created = Date()
                data.location = location
                data.effortValue = effortValue
            }
        }
        /// save the data
        do {
            try self.context.save()
        }
        catch {
        }
        
        /// Re-Fetch the data
        setupFetchedResultsData()
        calendar.reloadData()
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
            //            print(estimatedFrame.height)
            
            if estimatedFrame.height < 34 {
                tableView.rowHeight = 96
            }
            else {
                tableView.rowHeight = estimatedFrame.height + 60
            }
            
            return cell
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteTitle = NSLocalizedString("Delete", comment: "vc_table cell delete action")
        let deleteAction = UIContextualAction(style: .destructive, title: deleteTitle) { (_, _, completion) in
            /// figure out the data to delete
            guard let data = self.diffableDataSource.itemIdentifier(for: indexPath) else { return }
            self.context.delete(data)
            self.context.delete(data.toEventDate!)
            /// save the data
            do {
                try self.context.save()
            }
            catch {
            }
            
            /// Re-Fetch the data
            self.setupFetchedResultsData()
            self.calendar.reloadData()
            //            print("the deleted index is \(indexPath.row)"
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "AddRecord") as! AddViewController
        guard let data = self.diffableDataSource.itemIdentifier(for: indexPath) else { return }
        selectedDataArray.append(data)
        self.present(vc, animated: true, completion: nil)
        vc.doneBtn.setTitle(NSLocalizedString("Update", comment: "vc_cell data update"), for: .normal)
        
        /// update the textFiled data
        vc.activityField.text! = data.activityName!
        vc.detailField.text = data.detail!
        vc.detailField.textColor! = Theme.currentTheme.textColor
        vc.durationString = data.duration!
        vc.locationLabel = data.location!
        vc.colorTagString = data.colorTag
        vc.effortLabel = data.effortType
        
        /// update the duration data
        let duration = data.duration!
        
        if duration.contains(vo_h) && !duration.contains(vo_min) {
            /// hour only
            vc.durationPickView.selectRow(0, inComponent: 2, animated: false)
            if duration[1] == vo_h {
                vc.durationPickView.selectRow(Int(duration[0])!, inComponent: 1, animated: false)
            }
            else if duration[2] == vo_h {
                vc.durationPickView.selectRow(Int(duration[0 ..< 2])!, inComponent: 1, animated: false)
            }
        }
       
        else if !duration.contains(vo_h) && duration.contains(vo_min) {
            /// min only
            vc.durationPickView.selectRow(0, inComponent: 1, animated: false)
            if duration[1] == vo_m {
                vc.durationPickView.selectRow(Int(duration[0])!, inComponent: 2, animated: false)
            }
            else if duration[2] == vo_m {
                vc.durationPickView.selectRow(Int(duration[0 ..< 2])!, inComponent: 2, animated: false)
            }
        }
       
        else if duration.contains(vo_h) && duration.contains(vo_min) {
            if duration[1] == vo_h && duration[4] == vo_m {
                vc.durationPickView.selectRow(Int(duration[0])!, inComponent: 1, animated: false)
                vc.durationPickView.selectRow(Int(duration[3])!, inComponent: 2, animated: false)
                }
            else if duration[1] == vo_h && duration[5] == vo_m {
                    vc.durationPickView.selectRow(Int(duration[0])!, inComponent: 1, animated: false)
                    vc.durationPickView.selectRow(Int(duration[3 ..< 5])!, inComponent: 2, animated: false)
                }
            else if duration[2] == vo_h && duration[5] == vo_m {
                vc.durationPickView.selectRow(Int(duration[0 ..< 2])!, inComponent: 1, animated: false)
                vc.durationPickView.selectRow(Int(duration[4])!, inComponent: 2, animated: false)
                }
            else {
                    vc.durationPickView.selectRow(Int(duration[0 ..< 2])!, inComponent: 1, animated: false)
                    vc.durationPickView.selectRow(Int(duration[4 ..< 6])!, inComponent: 2, animated: false)
                }
        }
        
        /// update the location data
        if data.location == vo_gym {
            vc.locationPickView.selectedSegmentIndex = 0
        }
        else if data.location == vo_home {
            vc.locationPickView.selectedSegmentIndex = 1
        }
        else if data.location == vo_outside {
            vc.locationPickView.selectedSegmentIndex = 2
        }
        
        /// update the effort data
        if data.effortType == vo_veryLight {
            vc.effortPickView.selectRow(0, inComponent: 0, animated: false)
        }
        else if data.effortType == vo_light {
            vc.effortPickView.selectRow(1, inComponent: 0, animated: false)
        }
        else if data.effortType == vo_moderate {
            vc.effortPickView.selectRow(2, inComponent: 0, animated: false)
        }
        else if data.effortType == vo_vigorous {
            vc.effortPickView.selectRow(3, inComponent: 0, animated: false)
        }
        else if data.effortType == vo_hard {
            vc.effortPickView.selectRow(4, inComponent: 0, animated: false)
        }
        else if data.effortType == vo_max {
            vc.effortPickView.selectRow(5, inComponent: 0, animated: false)
        }
        
        /// update the color tag data
        if data.colorTag == "floraFirma" {
            vc.colorTagView.selectItem(at: [0, 0], animated: false, scrollPosition: .init())
        }
        else if data.colorTag == "chiveBlossom" {
            vc.colorTagView.selectItem(at: [0, 1], animated: false, scrollPosition: .init())
        }
        else if data.colorTag == "sulphurSpring" {
            vc.colorTagView.selectItem(at: [0, 2], animated: false, scrollPosition: .init())
        }
        else if data.colorTag == "pinkLemonade" {
            vc.colorTagView.selectItem(at: [0, 3], animated: false, scrollPosition: .init())
        }
        else if data.colorTag == "summerStorm" {
            vc.colorTagView.selectItem(at: [0, 4], animated: false, scrollPosition: .init())
        }
        else if data.colorTag == "oriole" {
            vc.colorTagView.selectItem(at: [0, 5], animated: false, scrollPosition: .init())
        }
        else if data.colorTag == "deepLake" {
            vc.colorTagView.selectItem(at: [0, 6], animated: false, scrollPosition: .init())
        }
        else if data.colorTag == "citrusSol" {
            vc.colorTagView.selectItem(at: [0, 7], animated: false, scrollPosition: .init())
        }
        else if data.colorTag == "butterRum" {
            vc.colorTagView.selectItem(at: [0, 8], animated: false, scrollPosition: .init())
        }
        else if data.colorTag == "turquoise" {
            vc.colorTagView.selectItem(at: [0, 9], animated: false, scrollPosition: .init())
        }
        else if data.colorTag == "ibizaBlue" {
            vc.colorTagView.selectItem(at: [0, 10], animated: false, scrollPosition: .init())
        }
        else if data.colorTag == "vivacious" {
            vc.colorTagView.selectItem(at: [0, 11], animated: false, scrollPosition: .init())
        }
        
        vc.addDataDelegate = self
    }
    
}

extension String {
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

// MARK: - Google Ads Banner
extension ViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("received ads")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error)
    }
}


