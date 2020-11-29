//
//  FontSizeController.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 2020/11/06.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit

class FontSizeController: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var mySlider: UISlider!
    @IBOutlet weak var sampleSentence: UILabel!
    @IBOutlet weak var defaultSizeMark: UILabel!
    @IBOutlet weak var smallA: UILabel!
    @IBOutlet weak var bigA: UILabel!
    
    var backIcon: UIImage!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if Theme.currentTheme.accentColor == UIColor.applyColor(AssetsColor.paleBrown) {
            return .darkContent
        }
        else {
            return .lightContent
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        let adjustFontSize = UserDefaults.standard.float(forKey: "adjustFontSize")
        mySlider.setValue(adjustFontSize, animated: false)
        dragToChangeFontSize(mySlider)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presetup()
        setupNavBar()
        applyTheme()
    }
    
    func presetup() {
        backIcon = UIImage(named: "leftArrow")
        let tempImg = backIcon.withRenderingMode(.alwaysTemplate)
        backBtn.setImage(tempImg, for: .normal)
        
        sampleSentence.text = NSLocalizedString("The average font size will adjust to your preferred reading size below.", comment: "font size sample text")
        
        smallA.text = NSLocalizedString("smallA", comment: "font size sample mark")
        bigA.text = NSLocalizedString("bigA", comment: "font size sample mark")
        defaultSizeMark.text = NSLocalizedString("default_font_size", comment: "font size default mark")
    }
    
    func applyTheme() {
        view.backgroundColor = Theme.currentTheme.backgroundColor
        backBtn.tintColor = Theme.currentTheme.accentColor
        mySlider.maximumTrackTintColor = Theme.currentTheme.cancelBtnColor
        mySlider.minimumTrackTintColor = Theme.currentTheme.accentColor
        smallA.textColor = Theme.currentTheme.textColor
        bigA.textColor = Theme.currentTheme.textColor
        sampleSentence.textColor = Theme.currentTheme.textColor
        defaultSizeMark.textColor = Theme.currentTheme.textColor
        navTitle.textColor = Theme.currentTheme.headerTitleColor
    }
    
    func setupNavBar() {
        navTitle.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        navTitle.text = NSLocalizedString("Font Size", comment: "enter the font size page")
        navTitle.alpha = 0.7
    }
  
    @IBAction func dragToChangeFontSize(_ sender: UISlider) {
        
        /// get the value (not float, should be integer) - it will just snap from one to the other
        mySlider.value = roundf(mySlider.value)
        
        UserDefaults.standard.set(sender.value, forKey: "adjustFontSize")
        
        switch mySlider.value {
        case 1:
            FontSizeControl.currentFontSize = DefaultFontSize()
            sampleSentence.font = FontSizeControl.currentFontSize.cellTextSize
            defaultSizeMark.isHidden = false
        case 2:
            FontSizeControl.currentFontSize = X2FontSize()
            sampleSentence.font = FontSizeControl.currentFontSize.cellTextSize
            defaultSizeMark.isHidden = true
        case 3:
            FontSizeControl.currentFontSize = X3FontSize()
            sampleSentence.font = FontSizeControl.currentFontSize.cellTextSize
            defaultSizeMark.isHidden = true
        case 4:
            FontSizeControl.currentFontSize = X4FontSize()
            sampleSentence.font = FontSizeControl.currentFontSize.cellTextSize
            defaultSizeMark.isHidden = true
        default:
            break
        }
      
    }
    
}
