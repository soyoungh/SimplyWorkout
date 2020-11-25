//
//  AddViewController.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 14/07/2020.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit

protocol AddData {
    func addWorkoutData (activity: String, detail: String, effortType: String, duration: String, colorType: String, location: String, effortValue: Float)
}

class AddViewController: UIViewController {
    
    @IBOutlet weak var t_ColorTag: UILabel!
    @IBOutlet weak var t_Exercise: UILabel!
    @IBOutlet weak var t_Duration: UILabel!
    @IBOutlet weak var t_Location: UILabel!
    @IBOutlet weak var t_Intensity: UILabel!
    
    @IBOutlet weak var icon_tag: UIImageView!
    @IBOutlet weak var icon_pencil: UIImageView!
    @IBOutlet weak var icon_time: UIImageView!
    @IBOutlet weak var icon_location: UIImageView!
    @IBOutlet weak var icon_meter: UIImageView!
    
    @IBOutlet weak var colorTagView: UICollectionView!
    @IBOutlet weak var effortPickView: UIPickerView!
    @IBOutlet weak var durationPickView: UIPickerView!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var activityField: UITextField!
    @IBOutlet weak var detailField: UITextView!
    @IBOutlet weak var locationPickView: UISegmentedControl!
    
    /// Sending Datas
    var addDataDelegate: AddData?
    var activityLabel: String?
    var detailLabel: String?
    var effortLabel: String?
    var durationLabel: String?
    var locationLabel: String?
    let colorTag = [AssetsColor.floraFirma, .bodacious, .sulphurSpring, .pinkLemonade, .summerStorm, .oriole, .barrierReef, .citrusSol, .butterRum, .turquoise, .ibizaBlue, .raspberries]
    var colorTagString: String?
    var effortValue: Float?
    
    /// DurationPickerView Properties
    var durationString: String?
    let hoursNum = Array(0...24)
    let minuteNum = Array(0...59)
    
    /// Related Controller Connection
    var effortScaleCtrl = EffortScalePicker()
    var progressBarCtrl = ProgressBar()
    var configuarationCtrl = ConfigurationsController()
    var firstSelectionIndexPath: IndexPath?
    var isFilled: Bool = false
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTapped(_ sender: UIButton) {
        dismissCheck()
    }
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            locationLabel = " Gym "
        }
        else if sender.selectedSegmentIndex == 1 {
            locationLabel = " Home "
        }
        else if sender.selectedSegmentIndex == 2 {
            locationLabel = " Outside "
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLayerSet()
        
        effortPickView.dataSource = effortScaleCtrl
        effortPickView.delegate = effortScaleCtrl
        effortPickView.selectRow(2, inComponent: 0, animated: false)
        
        colorTagView.dataSource = self
        colorTagView.delegate = self
  
        durationPickView.delegate = self
        durationPickView.dataSource = self
        
        durationPickView.selectRow(0, inComponent: 1, animated: true)
        durationPickView.selectRow(0, inComponent: 2, animated: true)
  
        activityField.delegate = self
        detailField.delegate = self
        
    }
 
    // MARK: - PreSetup Layouts
    private func viewLayerSet() {
        view.backgroundColor = Theme.currentTheme.backgroundColor
        
        activityField.backgroundColor = Theme.currentTheme.tagCellColor
        activityField.attributedPlaceholder = NSAttributedString(string: "Add a type of exercise here.", attributes: [NSAttributedString.Key.foregroundColor: Theme.currentTheme.opacityText])
        activityField.layer.masksToBounds = true
        activityField.layer.cornerRadius = 5
        activityField.layer.borderWidth = 1
        activityField.layer.borderColor = Theme.currentTheme.separatorColor.cgColor
        activityField.textColor = Theme.currentTheme.textColor
        activityField.font = FontSizeControl.currentFontSize.add_fieldTextSize
        doneBtn.titleLabel!.text = "Done"
        
        colorTagView.customView()
        
        cancelBtn.roundedCornerBtn()
        cancelBtn.titleLabel!.font = FontSizeControl.currentFontSize.btnTextSize
        cancelBtn.backgroundColor = Theme.currentTheme.cancelBtnColor
        cancelBtn.tintColor = Theme.currentTheme.weekdayTextColor
        
        doneBtn.roundedCornerBtn()
        doneBtn.titleLabel!.font = FontSizeControl.currentFontSize.btnTextSize
        doneBtn.backgroundColor = Theme.currentTheme.accentColor
        doneBtn.tintColor = Theme.currentTheme.textColorInDarkBg
        
        detailField.customTextView()
        detailField.font = FontSizeControl.currentFontSize.add_fieldTextSize
        detailField.text = "Give some details.(optional)"
        detailField.textColor = Theme.currentTheme.opacityText
        detailField.backgroundColor = Theme.currentTheme.tagCellColor
        
        locationPickView.selectedSegmentTintColor = Theme.currentTheme.segmentColor
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Theme.currentTheme.opacityText], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Theme.currentTheme.textColor], for: .selected)
        
        t_ColorTag.detailPageTitleSet()
        t_Exercise.detailPageTitleSet()
        t_Duration.detailPageTitleSet()
        t_Location.detailPageTitleSet()
        t_Intensity.detailPageTitleSet()
        
        icon_tag.imageViewSet()
        icon_pencil.imageViewSet()
        icon_time.imageViewSet()
        icon_location.imageViewSet()
        icon_meter.imageViewSet()
        
        hourLabel.timeLabelSet()
        minLabel.timeLabelSet()
        
    }
    // MARK: - Data Delegate
    func dismissCheck() {
        /// Activity and detail Field Check First!
        if activityField.text != "" || detailField.text != "Give some details.(optional)" {
            /// Save datas and deliver the blief to the table View
            guard let del = addDataDelegate else {
                return
            }
            nilValueCheck()
            del.addWorkoutData(activity: activityLabel!, detail: detailLabel!, effortType: effortLabel!, duration: durationLabel!, colorType: colorTagString ?? "floraFirma", location: locationLabel ?? " Gym ", effortValue: effortValue!)
            
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        else {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func nilValueCheck() {
        /// check for the activity Label
        if activityField.text == "" {
            activityLabel = "  "
        }
        else {
            activityLabel = activityField.text
        }
        
        ///check for the detail Label
        if detailField.text == "Give some details.(optional)" {
            detailLabel = "  "
        }
        else {
            detailLabel = detailField.text
        }
        
        /// check for the Duration Label
        if durationString == "" {
            durationLabel = "0h 0min"
        }
        else {
            durationLabel = durationString!
        }
        
        /// check for the Effort Scale Label
        if effortScaleCtrl.userEffortScale == "" {
            effortLabel = "Moderate"
        }
        
        if effortPickView.selectedRow(inComponent: 0) == 0 {
            effortLabel = "Very Light"
        }
        else if effortPickView.selectedRow(inComponent: 0) == 1 {
            effortLabel = "Light"
        }
        else if effortPickView.selectedRow(inComponent: 0) == 2 {
            effortLabel = "Moderate"
        }
        else if effortPickView.selectedRow(inComponent: 0) == 3 {
            effortLabel = "Vigorous"
        }
        else if effortPickView.selectedRow(inComponent: 0) == 4 {
            effortLabel = "Hard"
        }
        else if effortPickView.selectedRow(inComponent: 0) == 5 {
            effortLabel = "Max"
        }
        
        /// update the location data
        if locationLabel == " Gym " {
            locationPickView.selectedSegmentIndex = 0
        }
        else if locationLabel == " Home " {
            locationPickView.selectedSegmentIndex = 1
        }
        else if locationLabel == " Outside " {
            locationPickView.selectedSegmentIndex = 2
        }
        
        if effortLabel == "Very Light" {
            effortValue = 0.1
        }
        else if effortLabel == "Light" {
            effortValue = 0.2
        }
        else if effortLabel == "Moderate" {
            effortValue = 0.4
        }
        else if effortLabel == "Vigorous" {
            effortValue = 0.6
        }
        else if effortLabel == "Hard" {
            effortValue = 0.8
        }
        else if effortLabel == "Max" {
            effortValue = 1.0
        }
    }
    
    private func confitureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
}

// MARK: - UICollectionView Delegation
extension AddViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorTag.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! ColorTagCell
        
        let tag = colorTag[indexPath.row]
        
        cell.frame.size = CGSize(width:32, height: 32)
        cell.backgroundColor = UIColor.clear
        cell.setCell(tag)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tag = colorTag[indexPath.row]
        colorTagString = "\(tag)"
        
        let categoryRequest = CategoryCD.createFetchRequest()
        do {
            let categoryDataResults = try context.fetch(categoryRequest)
            let key = categoryDataResults.filter { $0.colorTag_c == colorTagString }
            for data in key {
                if data.colorTag_c == colorTagString {
                    activityField.text = data.activityName_c
                }
            }
        }
        catch let err {
            print(err)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 17, bottom: 10, right: 17)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        var space = CGFloat()
        
        if collectionView.frame.size.width > 340 {
            
            space = 25
        }
        else {
            space = 16
        }
        
        return space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}


// MARK: - UITextField Delegation
extension AddViewController: UITextFieldDelegate, UITextViewDelegate {
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        confitureTapGesture()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activityField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        /// Combine the textView text and the replacement text to create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        /// If updated text view will be empty, add the placeholder and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
            /// Else if the text view's placeholder is showing and the length of the replacement string is greater than 0, set the text color to black then set its text to the replacement string
        else if textView.textColor == UIColor.systemGray2 && !text.isEmpty {
            textView.textColor = Theme.currentTheme.textColor
            textView.text = text
        }
        else if textView.textColor == UIColor.darkGray && !text.isEmpty {
            textView.textColor = Theme.currentTheme.textColor
            textView.text = text
        }
            /// For every other case, the text should change with the usual behavior...
        else {
            return true
        }
        /// ...otherwise return false since the updates have already been made
        return false
    }
}

// MARK: - Duration PickerView Delegation
extension AddViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return 0
        }
        else if component == 1 {
            return hoursNum.count
        }
        else if component == 2 {
            return minuteNum.count
        }
        else {
            return 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return ""
        }
        else if component == 1 {
            return String(hoursNum[row])
        }
        else if component == 2 {
            return String(minuteNum[row])
        }
        else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {

        if component == 0 {
            return 20
        }
        else if component == 1 {
            return 120
        }
        else if component == 2 {
            return 120
        }
        else {
            return 60
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.font = FontSizeControl.currentFontSize.pickerTextSize
        pickerLabel.textColor = Theme.currentTheme.textColor
        
        switch component {
        case 1:
            pickerLabel.text = String(hoursNum[row])
            pickerLabel.textAlignment = .center
        case 2:
            pickerLabel.text = String(minuteNum[row])
            pickerLabel.textAlignment = .center
        default: break
        }
        
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let hour = hoursNum[pickerView.selectedRow(inComponent: 1)]
        let min = minuteNum[pickerView.selectedRow(inComponent: 2)]
        
        if hour == 0 && min != 0 {
            durationString = "\(min)min"
        }
        else if hour != 0 && min == 0 {
            durationString = "\(hour)h"
        }
        else if hour != 0 && min != 0 {
            durationString = "\(hour)h \(min)min"
            //print("both")
        }
        else {
            return
        }
        
        if hour == 1 {
            hourLabel.text = "hour"
        } else {
            hourLabel.text = "hours"
        }
        pickerView.reloadAllComponents()
    }
}


