//
//  MonthlyReportCtrl.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 2020/11/11.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit
import CoreData
import FSCalendar
import Charts

class MonthlyReportCtrl: UITableViewController, ChartViewDelegate, FSCalendarDelegate, FSCalendarDataSource, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var reportTable: UITableView!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var nexBtn: UIButton!
    
    @IBOutlet weak var totalLoggedNumber: UILabel!
    @IBOutlet weak var workoutsLabel: UILabel!
    @IBOutlet weak var hourNumber: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteNumber: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var headerCalendar: FSCalendar!
    
    var backIcon: UIImage!
    var nextIcon: UIImage!
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM"
        return formatter
    }()
    
    /// CoreData Stack
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //    let players = ["K.S. Williamson", "S.P.D. Smith", "V. Kohli", "Sachin", "J.J. Bumrah", "R.A. Jadeja"]
    //    let hundreds = [6, 8, 26, 30, 8, 10]
    var pieChart = PieChartView()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preSetup()
        setupNavBar()
        applyTheme()
        totalLoggedNumber.text = "\(totalLogNumber())"
        
        pieChart.delegate = self
    }
    
    @IBAction func preBtnTapped(_ sender: UIButton) {
        headerCalendar.setCurrentPage(getPreviousMonth(date: headerCalendar.currentPage), animated: true)
        reportNumberLabel()
    }
    
    @IBAction func nexBtnTapped(_ sender: UIButton) {
        headerCalendar.setCurrentPage(getNextMonth(date: headerCalendar.currentPage), animated: true)
        reportNumberLabel()
    }
    
    func getNextMonth(date: Date) -> Date {
        return Calendar.current.date(byAdding: .month, value: 1, to: date)!
    }
    
    func getPreviousMonth(date: Date) -> Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: date)!
    }
    
    func totalLogNumber() -> Int {
        let dateString = dateFormatter.string(from: headerCalendar.currentPage)
        let request = WorkoutDataCD.createFetchRequest()
        
        do {
            let dataResults = try context.fetch(request)
            let count = dataResults.filter { $0.toEventDate!.activityDate!.hasPrefix(dateString)}.count
            return count
        }
        catch let err {
            print(err)
        }
        
        return 0
    }
    
    func totalDurationNumber() -> (Int, Int) {
        let dateString = dateFormatter.string(from: headerCalendar.currentPage)
        let request = WorkoutDataCD.createFetchRequest()
        
        do {
            let dataResults = try context.fetch(request)
            let key = dataResults.filter { $0.toEventDate!.activityDate!.hasPrefix(dateString)}
            
            var hourArray = [Int]()
            var minArray = [Int]()
            for data in key {
                let duration = data.duration!.split(separator: " ")
                for item in duration {
                    if item.contains("h") == true {
                        let numOnlyforHour = item.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                        hourArray.append(Int(numOnlyforHour)!)
                    }
                    else if item.contains("min") == true {
                        let numOnlyforMin = item.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                        minArray.append(Int(numOnlyforMin)!)
                    }
                }
            }
            let hourNum = hourArray.reduce(.zero, +)
            let minNum = minArray.reduce(.zero, +)
            return (hourNum, minNum)
        }
        catch let err {
            print(err)
        }
        return (0, 0)
    }
    
    func reportNumberLabel() {
        totalLoggedNumber.text = "\(totalLogNumber())"
        hourNumber.text = "\(totalDurationNumber().0)"
        minuteNumber.text = "\(totalDurationNumber().1)"
        reportTable.reloadData()
    }
    
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //
    //        var entries = [ChartDataEntry]()
    //
    //        for i in 0..<players.count {
    //            let dataEntry = PieChartDataEntry(value: Double(hundreds[i]), label: players[i], data: players[i] as AnyObject)
    //            entries.append(dataEntry)
    //        }
    //
    //        let set = PieChartDataSet(entries: entries, label: nil)
    //        set.colors = ChartColorTemplates.liberty()
    //
    //        let data = PieChartData(dataSet: set)
    //        let format = NumberFormatter()
    //        format.numberStyle = .percent
    //        let formatter = DefaultValueFormatter(formatter: format)
    //        data.setValueFormatter(formatter)
    //        pieChart.data = data
    //        pieChart.dragDecelerationEnabled = false
    //        pieChart.drawEntryLabelsEnabled = false
    //    }
    
    func preSetup() {
        headerCalendar.calendarWeekdayView.isHidden = true
        headerCalendar.collectionView.isHidden = true
        headerCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
        headerCalendar.backgroundColor = UIColor.clear
        headerCalendar.appearance.headerDateFormat = "MMMM YYYY"
        headerCalendar.appearance.headerTitleFont = FontSizeControl.currentFontSize.reportMonthLabel
        
        backIcon = UIImage(named: "leftArrow")
        let tempImg1 = backIcon.withRenderingMode(.alwaysTemplate)
        prevBtn.setImage(tempImg1, for: .normal)
        
        nextIcon = UIImage(named: "leftArrow")
        let tempImg2 = nextIcon.withRenderingMode(.alwaysTemplate)
        nexBtn.setImage(tempImg2, for: .normal)
        nexBtn.transform = nexBtn.transform.rotated(by: .pi)
        
        workoutsLabel.alpha = 0.5
        hourLabel.alpha = 0.5
        minuteLabel.alpha = 0.5
    }
    
    func setupNavBar() {
        navTitle.font = FontSizeControl.currentFontSize.c_headerTextSize
        navTitle.text = "Monthly Workout Report"
    }
    
    func applyTheme() {
        view.backgroundColor = Theme.currentTheme.backgroundColor
        reportTable.backgroundColor = Theme.currentTheme.backgroundColor
        prevBtn.tintColor = Theme.currentTheme.separatorColor
        nexBtn.tintColor = Theme.currentTheme.separatorColor
        navTitle.textColor = Theme.currentTheme.headerTitleColor
        headerCalendar.appearance.headerTitleColor = Theme.currentTheme.accentColor
        totalLoggedNumber.textColor = UIColor.applyColor(AssetsColor.livingCoral)
        workoutsLabel.textColor = Theme.currentTheme.textColor
        hourNumber.textColor = UIColor.applyColor(AssetsColor.floraFirma)
        hourLabel.textColor = Theme.currentTheme.textColor
        minuteNumber.textColor = UIColor.applyColor(AssetsColor.floraFirma)
        minuteLabel.textColor = Theme.currentTheme.textColor
        
        reportTable.reloadData()
    }
    
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 28))
        header.backgroundColor = .clear
        let headerText = UILabel(frame: CGRect(x: 20, y: 0, width: 180, height: tableView.sectionHeaderHeight))
        
        switch section {
        case 0:
            headerText.text = "LOGGED THIS MONTH"
        case 1:
            headerText.text = "TOTAL DURATION"
        case 2:
            headerText.text = "FREQUENTLY LOGGED EXERCISE"
        default:
            break
        }
        
        headerText.textColor = Theme.currentTheme.headerTitleColor
        headerText.font = FontSizeControl.currentFontSize.headerTextSize
        headerText.alpha = 0.68
        header.addSubview(headerText)
        header.addBottomBorder(0.5)
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20))
        footer.addTopBorder(0.5)
        return footer
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = Theme.currentTheme.lightCellColor
        cell.selectionStyle = .none
        tableView.separatorColor = Theme.currentTheme.separatorColor
        
        if indexPath == [2, 0] {
            pieChart.frame = CGRect(x: 0, y: 0, width: 320, height: 320)
            pieChart.center = cell.contentView.center
            cell.contentView.addSubview(pieChart)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath {
        case [0, 0]:
            return 60
        case [1, 0]:
            return 60
        case [2, 0]:
            return 360
        default:
            return 60
        }
    }
    
    func numberOfLog() -> Int {
        
        
        
        return 0
    }
}
