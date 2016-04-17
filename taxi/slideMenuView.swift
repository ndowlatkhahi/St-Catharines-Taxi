//
//  QuotesSearchView.swift
//  taxi
//
//  Created by Vali Dowlatkhahi on 2016-04-16.
//  Copyright © 2016 Vali Dowlatkhahi. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(index : Int32, slideMenu: slideMenuView)
}

class slideMenuView: UIView {

    var delegate : SlideMenuDelegate?
    var btnMenu : UIButton!

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var getTaxiButton: UIButton!
    @IBOutlet weak var recentsButton: UIButton!
    @IBOutlet weak var bookingsButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        
    }
    
    func setSelected(index: Int32)
    {
        
        let grayColor = UIColor(colorLiteralRed: 61/255, green: 61/255, blue: 61/255, alpha: 1)
        let yellowColor = UIColor(colorLiteralRed: 255/255, green: 235/255, blue: 47/255, alpha: 1)
        let whiteColor = UIColor.whiteColor()
        
        if index == 1 {
            self.getTaxiButton.backgroundColor = grayColor
            self.getTaxiButton.setTitleColor(whiteColor, forState: .Normal)
            self.bookingsButton.backgroundColor = grayColor
            self.bookingsButton.setTitleColor(whiteColor, forState: .Normal)
            self.settingsButton.backgroundColor = grayColor
            self.settingsButton.setTitleColor(whiteColor, forState: .Normal)
            self.recentsButton.backgroundColor = yellowColor
            self.recentsButton.setTitleColor(grayColor, forState: .Normal)
        } else if index == 2{
            self.getTaxiButton.backgroundColor = grayColor
            self.getTaxiButton.setTitleColor(whiteColor, forState: .Normal)
            self.bookingsButton.backgroundColor = yellowColor
            self.bookingsButton.setTitleColor(grayColor, forState: .Normal)
            self.settingsButton.backgroundColor = grayColor
            self.settingsButton.setTitleColor(whiteColor, forState: .Normal)
            self.recentsButton.backgroundColor = grayColor
            self.recentsButton.setTitleColor(whiteColor, forState: .Normal)
        } else if index == 3{
            self.getTaxiButton.backgroundColor = grayColor
            self.getTaxiButton.setTitleColor(whiteColor, forState: .Normal)
            self.bookingsButton.backgroundColor = grayColor
            self.bookingsButton.setTitleColor(whiteColor, forState: .Normal)
            self.settingsButton.backgroundColor = yellowColor
            self.settingsButton.setTitleColor(grayColor, forState: .Normal)
            self.recentsButton.backgroundColor = grayColor
            self.recentsButton.setTitleColor(whiteColor, forState: .Normal)
        } else if index == 4{
            self.getTaxiButton.backgroundColor = yellowColor
            self.getTaxiButton.setTitleColor(grayColor, forState: .Normal)
            self.bookingsButton.backgroundColor = grayColor
            self.bookingsButton.setTitleColor(whiteColor, forState: .Normal)
            self.settingsButton.backgroundColor = grayColor
            self.settingsButton.setTitleColor(whiteColor, forState: .Normal)
            self.recentsButton.backgroundColor = grayColor
            self.recentsButton.setTitleColor(whiteColor, forState: .Normal)
        }
    }
    
    @IBAction func onCloseMenuClick(button:UIButton!){

        if (self.delegate != nil) {
            let index = Int32(button.tag)
            delegate?.slideMenuItemSelectedAtIndex(index, slideMenu: self)
        }
    }

}
