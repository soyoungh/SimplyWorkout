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

class MonthlyReportCtrl: UITableViewController, FSCalendarDelegate, FSCalendarDataSource, UIGestureRecognizerDelegate, ChartViewDelegate {
    
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var reportTable: UITableView!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var nexBtn: UIButton!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var totalLoggedNumber: UILabel!
    @IBOutlet weak var workoutsLabel: UILabel!
    @IBOutlet weak var hourNumber: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteNumber: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var headerCalendar: FSCalendar!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var lineChart_lightLabel: UILabel!
    @IBOutlet weak var lineChart_maxLabel: UILabel!
    @IBOutlet weak var effortGraphic: UIView!
    
    var preIcon: UIImage!
    var nextIcon: UIImage!
    var backIcon: UIImage!
    
    var effortArray = [Float]()
    var dateArray = [String]()
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM"
        return formatter
    }()
    
    /// CoreData Stack
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        reportNumberLabel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preSetup()
        setupNavBar()
        setupPieChart()
        setupLineChart()
        applyTheme()
        lineChartView.xAxis.valueFormatter = self
        lineChartView.delegate = self
        
//        lineChart_lightLabel.isHidden = true
//        lineChart_maxLabel.isHidden = true
    }
    
    // MARK: - Button Tap Actions
    @IBAction func preBtnTapped(_ sender: UIButton) {
        headerCalendar.setCurrentPage(getPreviousMonth(date: headerCalendar.currentPage), animated: true)
        dateArray.removeAll()
        reportNumberLabel()
    }
    
    @IBAction func nexBtnTapped(_ sender: UIButton) {
        headerCalendar.setCurrentPage(getNextMonth(date: headerCalendar.currentPage), animated: true)
        dateArray.removeAll()
        reportNumberLabel()
    }
    
    @objc func backBtnTapped(sender: UIButton!) {
        let vc = storyboard?.instantiateViewController(identifier: "mainView") as! ViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getNextMonth(date: Date) -> Date {
        return Calendar.current.date(byAdding: .month, value: 1, to: date)!
    }
    
    func getPreviousMonth(date: Date) -> Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: date)!
    }
    
    // MARK: - Data Delegate
    func reportNumberLabel() {
        totalLoggedNumber.text = "\(totalLogNumber())"
        hourNumber.text = "\(totalDurationNumber().0)"
        minuteNumber.text = "\(totalDurationNumber().1)"
        pieGraphData()
        setLineChart(dataEntryX: dateArray, dataEntryY: effortArray)
        reportTable.reloadData()
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
            var hourNum = hourArray.reduce(.zero, +)
            var minNum = minArray.reduce(.zero, +)
            
            while minNum > 59 {
                minNum -= 60
                hourNum += 1
            }
            
            return (hourNum, minNum)
        }
        catch let err {
            print(err)
        }
        return (0, 0)
    }
    
    /// PieChart Data
    func pieGraphData() {
        var entries = [ChartDataEntry]()
        
        let dateString = dateFormatter.string(from: headerCalendar.currentPage)
        let request = WorkoutDataCD.createFetchRequest()
        let sort = NSSortDescriptor(key: "toEventDate.activityDate", ascending: true)
        let predicate = NSPredicate(format: "toEventDate.activityDate CONTAINS %@", dateString)
        request.sortDescriptors = [sort]
        request.predicate = predicate
        
        do {
            let dataResults = try context.fetch(request)
            
            var activityArray = [String]()
            var colorDictionary = [String : String]()
            var colorSet = [UIColor]()
            
            for data in dataResults {
                let userActivity = data.activityName
                activityArray.append(userActivity!)
                
                let colorTag = data.colorTag
                colorDictionary[userActivity!] = colorTag
                
                let userEffort = data.effortValue
                let date = data.toEventDate!.activityDate
                
                let dateWords = date!.split(separator: "/")
                let lastTwo = String(dateWords.suffix(2).joined(separator: ["."]))
                
                dateArray.append(lastTwo)
                effortArray.append(userEffort)
            }
            
            let frequency = activityArray.frequency
            for (key, value) in frequency {
                
                let dataEntry = PieChartDataEntry(value: Double(value), label: key, data: key as AnyObject)
                entries.append(dataEntry)
                
                for (act, color) in colorDictionary {
                    if dataEntry.label == act {
                        colorSet.append(UIColor(named: color)!)
                    }}}
            
            let dataSet = PieChartDataSet(entries: entries, label: nil)
            dataSet.colors = colorSet
            dataSet.entryLabelColor = UIColor.white // block text color
            let data = PieChartData(dataSet: dataSet)
            let format = NumberFormatter()
            format.numberStyle = .percent
            format.multiplier = 1
            format.minimumFractionDigits = 1
            format.maximumFractionDigits = 2
            let formatter = DefaultValueFormatter(formatter: format)
            data.setValueFormatter(formatter)
            pieChartView.data = data
            pieChartView.animate(yAxisDuration: 2.5)
            /// show block text
            //            pieChart.drawEntryLabelsEnabled = false
            
        }
        catch let err {
            print(err)
        }
    }
    
    func setLineChart(dataEntryX forX:[String], dataEntryY forY: [Float]) {
        var lineEntries = [ChartDataEntry]()
        for i in 0..<forX.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(forY[i]), data: dateArray as AnyObject?)
            lineEntries.append(dataEntry)
        }
        
        let dataSet = LineChartDataSet(entries: lineEntries, label: nil)
        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 2
        dataSet.drawCirclesEnabled = true
        dataSet.circleRadius = 4.0
        dataSet.circleHoleRadius = 2.0
        dataSet.circleColors = [Theme.currentTheme.accentColor]
        dataSet.circleHoleColor = Theme.currentTheme.backgroundColor as NSUIColor
        
//        dataSet.fillAlpha = 0.8
//        dataSet.fill = Fill(color: .white)
        dataSet.drawHorizontalHighlightIndicatorEnabled = true
//        dataSet.highlightColor = .red
        dataSet.colors = [Theme.currentTheme.accentColor]
        dataSet.drawFilledEnabled = false // Draw the Gradient
  
        let data = LineChartData(dataSet: dataSet)
        data.setDrawValues(false)
        lineChartView.data = data
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = Theme.currentTheme.textColorInDarkBg
        label.textAlignment = .center
        
        if highlight.y == 1.0 {
            label.text = "Max"
            label.backgroundColor = UIColor.applyColor(AssetsColor.raspberries)
        }
        else if highlight.y >= 0.8 {
            label.text = "Hard"
            label.backgroundColor = UIColor.applyColor(AssetsColor.oriole)
        }
        else if highlight.y >= 0.6 {
            label.text = "Vigorous"
            label.backgroundColor = UIColor.applyColor(AssetsColor.citrusSol)
        }
        else if highlight.y >= 0.4 {
            label.text = "Moderate"
            label.backgroundColor = UIColor.applyColor(AssetsColor.sulphurSpring)
        }
        else if highlight.y >= 0.2 {
            label.text = "Light"
            label.backgroundColor = UIColor.applyColor(AssetsColor.floraFirma)
        }
        else if highlight.y >= 0.1 {
            label.text = "Very Light"
            label.backgroundColor = UIColor.applyColor(AssetsColor.barrierReef)
        }
        
        label.frame = CGRect(x: highlight.xPx-(label.intrinsicContentSize.width/2), y: highlight.yPx-25, width: label.intrinsicContentSize.width+8, height: 18)
        lineChartView.addSubview(label)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            label.isHidden = true
        }
    }
    
    // MARK: - View Layout Setup
    private var gradientLayer: CAGradientLayer!
    
    func preSetup() {
        headerCalendar.calendarWeekdayView.isHidden = true
        headerCalendar.collectionView.isHidden = true
        headerCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
        headerCalendar.backgroundColor = UIColor.clear
        headerCalendar.appearance.headerDateFormat = "MMMM YYYY"
        headerCalendar.appearance.headerTitleFont = FontSizeControl.currentFontSize.reportMonthLabel
        
        preIcon = UIImage(named: "next")
        let tempImg1 = preIcon.withRenderingMode(.alwaysTemplate)
        prevBtn.setImage(tempImg1, for: .normal)
        prevBtn.transform = prevBtn.transform.rotated(by: .pi)
        
        nextIcon = UIImage(named: "next")
        let tempImg2 = nextIcon.withRenderingMode(.alwaysTemplate)
        nexBtn.setImage(tempImg2, for: .normal)
        
        backIcon = UIImage(named: "leftArrow")
        let tempImg3 = backIcon.withRenderingMode(.alwaysTemplate)
        backBtn.setImage(tempImg3, for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        
        workoutsLabel.alpha = 0.5
        hourLabel.alpha = 0.5
        minuteLabel.alpha = 0.5
        
        let location: CGRect = effortGraphic.bounds
        gradientLayer = setGradientLayer(rect: location, startPoint: CGPoint(x: 0.0, y: 1.0), endPoint: CGPoint(x: 0.0, y: 0.0))
        
        effortGraphic.layer.addSublayer(gradientLayer)

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
        backBtn.tintColor = Theme.currentTheme.accentColor
        navTitle.textColor = Theme.currentTheme.headerTitleColor
        headerCalendar.appearance.headerTitleColor = Theme.currentTheme.accentColor
        totalLoggedNumber.textColor = UIColor.applyColor(AssetsColor.livingCoral)
        workoutsLabel.textColor = Theme.currentTheme.textColor
        hourNumber.textColor = UIColor.applyColor(AssetsColor.floraFirma)
        hourLabel.textColor = Theme.currentTheme.textColor
        minuteNumber.textColor = UIColor.applyColor(AssetsColor.floraFirma)
        minuteLabel.textColor = Theme.currentTheme.textColor
        headerCalendar.appearance.headerTitleFont = FontSizeControl.currentFontSize.reportMonthLabel
        reportTable.reloadData()
    }

    private func setGradientLayer (rect: CGRect, startPoint: CGPoint, endPoint: CGPoint) -> CAGradientLayer {
        
        let gradientLayer = CAGradientLayer()
       
        gradientLayer.type = .axial
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        gradientLayer.colors = [
            UIColor.applyColor(AssetsColor.barrierReef)!.cgColor, UIColor.applyColor(AssetsColor.turquoise)!.cgColor, UIColor.applyColor(AssetsColor.sulphurSpring)!.cgColor, UIColor.applyColor(AssetsColor.citrusSol)!.cgColor, UIColor.applyColor(AssetsColor.oriole)!.cgColor,
            UIColor.applyColor(AssetsColor.raspberries)!.cgColor]
        
        gradientLayer.frame = rect
        
        return gradientLayer
    }
    
    func setupPieChart() {
        pieChartView.chartDescription?.enabled = false
        pieChartView.drawHoleEnabled = true
        pieChartView.rotationAngle = 0
        pieChartView.rotationEnabled = false
        pieChartView.isUserInteractionEnabled = false
        pieChartView.dragDecelerationEnabled = false
        pieChartView.dragDecelerationFrictionCoef = 0
        pieChartView.isExclusiveTouch = false
        pieChartView.holeColor = UIColor.clear
        pieChartView.holeRadiusPercent = 0.35
        pieChartView.transparentCircleRadiusPercent = 0.4
        
        pieChartView.usePercentValuesEnabled = true // convert to percentage
        pieChartView.drawEntryLabelsEnabled = false // Show block text
        
        pieChartView.legend.maxSizePercent = 1 // % of the legend
        pieChartView.legend.form = .circle
        pieChartView.legend.formSize = 10
        pieChartView.legend.formToTextSpace = 6
        pieChartView.legend.font = FontSizeControl.currentFontSize.c_weekdayTextSize
        pieChartView.legend.textColor = Theme.currentTheme.weekdayTextColor
        pieChartView.legend.horizontalAlignment = .left
        pieChartView.legend.verticalAlignment = .bottom
    
    }
    
    func setupLineChart() {
        lineChartView.backgroundColor = .clear
        lineChartView.rightAxis.enabled = false
        
        let yAxis = lineChartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
//        yAxis.setLabelCount(6, force: true)
        yAxis.labelTextColor = Theme.currentTheme.textColor
        yAxis.axisLineColor = Theme.currentTheme.separatorColor
        yAxis.drawGridLinesEnabled = true
        yAxis.drawAxisLineEnabled = false
        yAxis.labelCount = 6
//        yAxis.granularity = 1
//        yAxis.axisMinimum = 0
        yAxis.axisMinimum = 0.0
        yAxis.axisMaximum = 1.1
        yAxis.drawLabelsEnabled = false
       
        let xAxis = lineChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont.systemFont(ofSize: 12, weight: .regular)
        xAxis.setLabelCount(5, force: false)
        xAxis.labelTextColor = Theme.currentTheme.textColor
        xAxis.axisLineColor = Theme.currentTheme.separatorColor
        xAxis.avoidFirstLastClippingEnabled = true
        xAxis.granularity = 1
        
//        lineChartView.setViewPortOffsets(left: 20, top: 20, right: 10, bottom: 20)
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.legend.enabled = false
//        lineChartView.animate(yAxisDuration: 2, easingOption: .easeInBack)
    }
    
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 28))
        header.backgroundColor = .clear
        let headerText = UILabel(frame: CGRect(x: 20, y: 0, width: 290, height: tableView.sectionHeaderHeight))
        
        switch section {
        case 0:
            headerText.text = "LOGGED THIS MONTH"
        case 1:
            headerText.text = "TOTAL DURATION"
        case 2:
            headerText.text = "FREQUENTLY LOGGED EXERCISE"
        case 3:
            headerText.text = "EFFORT SCALE OVERVIEW"
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
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath {
        case [0, 0]:
            return 60
        case [1, 0]:
            return 60
        case [2, 0]:
            return 280
        case [3, 0]:
            return 220
        default:
            return 60
        }
    }
}

extension Sequence where Element: Hashable {
    var frequency: [Element: Int] { reduce(into: [:]) { $0[$1, default: 0] += 1 } }
}

extension MonthlyReportCtrl: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateArray[Int(value)]
    }
}

extension StringProtocol {
    var byWords: [SubSequence] {
        var byWords: [SubSequence] = []
        enumerateSubstrings(in: startIndex..., options: .byWords) { _, range, _, _ in
            byWords.append(self[range])
        }
        return byWords
    }
}

//enum EffortScale: Float {
//    case veryLight
//    case light
//    case moderate
//    case vigorous
//    case hard
//    case max
//
//    var label: String {
//        switch self {
//        case .veryLight: return "Very Light"
//        case .light: return "Light"
//        case .moderate: return "Moderate"
//        case .vigorous: return "Vigorous"
//        case .hard: return "Hard"
//        case .max: return "Max"
//        }
//    }
//}

