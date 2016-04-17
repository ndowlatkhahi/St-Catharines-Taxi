//
//  FirstViewController.swift
//  taxi
//
//  Created by Vali Dowlatkhahi on 2016-04-15.
//  Copyright © 2016 Vali Dowlatkhahi. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {
    
    // labels
    @IBOutlet weak var titleLabel: UILabel!
    
    // buttons
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    
    // views
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var callView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var bottomNavView: UIView!
    
    var menuView : slideMenuView!
    var recentView: recentsView!
    var bookingView: bookingsView!
    var settingView: settingsView!
    var mapViewKit: MKMapView!
    
    // forms elements
    @IBOutlet weak var fromTextField: AutoCompleteTextField!
    @IBOutlet weak var toTextField: AutoCompleteTextField!
    @IBOutlet weak var psgButton1: UIButton!
    @IBOutlet weak var psgButton2: UIButton!
    @IBOutlet weak var psgButton3: UIButton!
    @IBOutlet weak var cashButton: UIButton!
    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    
    var dialogueClosed: Bool = true
    var selectedNumPassengers: UIButton!
    var selectedPaymentMethod: UIButton!
    var currentIndex : Int32 = 0
    
    // Google Places Settings
    private var responseData:NSMutableData?
    private var selectedPointAnnotation:MKPointAnnotation?
    private var dataTask:NSURLSessionDataTask?
    
    private let googleMapsKey = "AIzaSyDg2tlPcoqxx2Q2rfjhsAKS-9j0n3JA_a4"
    private let baseURLString = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    
    // constraints
    @IBOutlet weak var mapViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomNavLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomNavTrailingConstraint: NSLayoutConstraint!
    
    // toggle bool
    var toggle : Bool = true
    
    // gestures
    var tap : UITapGestureRecognizer!
    var leftSwipe: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        makeMenu()
        makeMap()
        
        configureTextField()
        handleTextFieldInterfaces()
        
        self.resetForm()

        self.toTextField.delegate = self
        self.fromTextField.delegate = self
        
        self.toTextField.keyboardAppearance = .Dark
        self.fromTextField.keyboardAppearance = .Dark
        
        self.hideKeyboardWhenTappedAround()
        
        self.selectedNumPassengers = psgButton1
        self.selectedPaymentMethod = cardButton
    }
    
    override func viewDidLayoutSubviews() {
        self.setAppearances()
    }
    
    
    func setMap(){
        let map = MKMapView(frame: self.mapView.bounds)
        self.mapViewKit = map
        self.mapView.addSubview(map)
    }
    
    // -- MARK: Class Functions --
    func setAppearances(){
        
        cashButton.backgroundColor = UIColor.clearColor()
        
        toTextField.setBottomBorder(UIColor.grayColor())
        fromTextField.setBottomBorder(UIColor.grayColor())
    }
    
    func makeMenu(){
        self.menuView = (NSBundle.mainBundle().loadNibNamed("menuView", owner: self, options: nil).last) as! slideMenuView
        menuView.frame = CGRectMake(-1 * self.view.frame.size.width - 80, self.mapView.frame.origin.y, self.view.frame.size.width - 80, self.view.bounds.size.height - self.mapView.frame.origin.y)
        
        self.menuView.delegate = self
        self.view.addSubview(menuView)
    }
    
    func makeRecent(){
        self.recentView = (NSBundle.mainBundle().loadNibNamed("recents", owner: self, options: nil).last) as! recentsView
        self.recentView.frame = CGRectMake(self.view.frame.size.width, self.mapView.frame.origin.y, self.view.frame.size.width, self.view.bounds.size.height - self.mapView.frame.origin.y)
        
        self.view.addSubview(recentView)
    }
    
    func makeBookings(){
        self.bookingView = (NSBundle.mainBundle().loadNibNamed("bookings", owner: self, options: nil).last) as! bookingsView
        self.bookingView.frame = CGRectMake(self.view.frame.size.width, self.mapView.frame.origin.y, self.view.frame.size.width, self.view.bounds.size.height - self.mapView.frame.origin.y)
        
        self.view.addSubview(bookingView)
    }
    
    func makeSettings(){
        self.settingView = (NSBundle.mainBundle().loadNibNamed("settings", owner: self, options: nil).last) as! settingsView
        self.settingView.frame = CGRectMake(self.view.frame.size.width, self.mapView.frame.origin.y, self.view.frame.size.width, self.view.bounds.size.height - self.mapView.frame.origin.y)
        
        self.view.addSubview(settingView)
    }
    
    func resetForm() {
        
        self.resetSelected(0)

        self.selectedNumPassengers = psgButton1
        self.selectedPaymentMethod = cardButton
        
        // set default highlighted button
        psgButton1.setBottomBorder(UIColor(colorLiteralRed: 255/255, green: 235/255, blue: 47/255, alpha: 1))
        cardButton.setBottomBorder(UIColor(colorLiteralRed: 255/255, green: 235/255, blue: 47/255, alpha: 1))
        
    }
    
    func resetSelected(section: Int) {
        
        if section == 0 {
            self.cashButton.setBottomBorder(UIColor.whiteColor())
            self.accountButton.setBottomBorder(UIColor.whiteColor())
            self.cardButton.setBottomBorder(UIColor.whiteColor())
            self.psgButton1.setBottomBorder(UIColor.whiteColor())
            self.psgButton2.setBottomBorder(UIColor.whiteColor())
            self.psgButton3.setBottomBorder(UIColor.whiteColor())
        }else if section == 1 {
            self.psgButton1.setBottomBorder(UIColor.whiteColor())
            self.psgButton2.setBottomBorder(UIColor.whiteColor())
            self.psgButton3.setBottomBorder(UIColor.whiteColor())
        }else if section == 2 {
            self.cashButton.setBottomBorder(UIColor.whiteColor())
            self.accountButton.setBottomBorder(UIColor.whiteColor())
            self.cardButton.setBottomBorder(UIColor.whiteColor())
        }
    }
    
    func makeMap(){
        let map = MKMapView(frame: self.mapView.bounds)
        self.mapView.addSubview(map)
    }
    
    func showMenu(){
        UIView.animateWithDuration(0.6, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            
            var newSlideMenuFrame       = self.menuView.frame
            newSlideMenuFrame.origin.x  = 0
            
            self.menuView.frame         = newSlideMenuFrame
            self.overlayView.alpha      = 0.5
            self.toggle                 = false
            self.overlayView.userInteractionEnabled = true

            self.view.layoutIfNeeded()
            
            }, completion: nil)
        
    }
    
    func hideMenu(){
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .CurveEaseInOut, animations: { () -> Void in
            
            var newSlideMenuFrame = self.menuView.frame
            newSlideMenuFrame.origin.x = -1 * self.view.frame.size.width - 80
            self.menuView.frame = newSlideMenuFrame
            
            if self.dialogueClosed {
                self.overlayView.alpha = 0
                self.overlayView.userInteractionEnabled = false
            }
            
            self.overlayView.removeGestureRecognizer(self.tap)
            self.menuView.removeGestureRecognizer(self.leftSwipe)
            self.callView.userInteractionEnabled = true
            self.searchView.userInteractionEnabled = true
            self.toggle = true
            
            self.view.layoutIfNeeded()
            
            }, completion: nil)
    }

    func hideAllDialogues(){
       self.callView.userInteractionEnabled = false
       self.searchView.userInteractionEnabled = false
    }
    
    // -- MARK: IBActions --
    
    @IBAction func makeCall(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://+12895012995")!)
    }
    
    @IBAction func setNumPassengers(sender: AnyObject) {
        
        if let numPassengerButton = sender as? UIButton {
            
            self.resetSelected(1)
            numPassengerButton.setBottomBorder(UIColor(colorLiteralRed: 255/255, green: 235/255, blue: 47/255, alpha: 1))
            
            self.selectedNumPassengers = numPassengerButton
        }
    }
    
    @IBAction func setPaymentType(sender: AnyObject) {
        if let paymentTypeBTN = sender as? UIButton {
            
            self.resetSelected(2)
            paymentTypeBTN.setBottomBorder(UIColor(colorLiteralRed: 255/255, green: 235/255, blue: 47/255, alpha: 1))
            
            self.selectedPaymentMethod = paymentTypeBTN
        }
    }
    
    @IBAction func slideMenu(sender: AnyObject) {
        
        if toggle {
            self.hideAllDialogues()
            self.showMenu()
            self.tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.hideMenu))            
            self.leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(HomeViewController.hideMenu))
            self.leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
            
            self.overlayView.addGestureRecognizer(self.tap)
            self.menuView.addGestureRecognizer(self.leftSwipe)
            
        }else{
            self.hideMenu()
        }
        
    }

    @IBAction func showSearch(sender: AnyObject){

        self.resetForm()
        
        UIView.animateWithDuration(0.2) {
            self.overlayView.alpha = 0.5
            self.searchView.alpha = 1
            self.searchView.userInteractionEnabled = true
            self.overlayView.userInteractionEnabled = true
            self.dialogueClosed = false
        }
    }
    

    @IBAction func hideSearch(sender: AnyObject){
        self.searchView.userInteractionEnabled = false
        self.overlayView.userInteractionEnabled = false
        UIView.animateWithDuration(0.2) {
            self.overlayView.alpha = 0
            self.searchView.alpha = 0
            self.dialogueClosed = true
        }

    }
    @IBAction func showPhone(sender: AnyObject) {
        UIView.animateWithDuration(0.2) {
            self.overlayView.alpha = 0.5
            self.callView.alpha = 1
            self.callView.userInteractionEnabled = true
            self.overlayView.userInteractionEnabled = true
            self.dialogueClosed = false
        }
    }
    @IBAction func hidePhone(sender: AnyObject) {
        self.callView.userInteractionEnabled = false
        self.overlayView.userInteractionEnabled = false
        UIView.animateWithDuration(0.2) {
            self.overlayView.alpha = 0
            self.callView.alpha = 0
            self.dialogueClosed = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // -- MARK: GOOGLE PLACES API ---
    private func configureTextField(){
        fromTextField.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        fromTextField.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)!
        fromTextField.autoCompleteCellHeight = 35.0
        fromTextField.maximumAutoCompleteCount = 20
        fromTextField.hidesWhenSelected = true
        fromTextField.hidesWhenEmpty = true
        fromTextField.enableAttributedText = true
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.blackColor()
        attributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        fromTextField.autoCompleteAttributes = attributes
        
        toTextField.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        toTextField.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)!
        toTextField.autoCompleteCellHeight = 35.0
        toTextField.maximumAutoCompleteCount = 20
        toTextField.hidesWhenSelected = true
        toTextField.hidesWhenEmpty = true
        toTextField.enableAttributedText = true
        toTextField.autoCompleteAttributes = attributes
    }
    
    private func handleTextFieldInterfaces(){
        fromTextField.onTextChange = {[weak self] text in
            if !text.isEmpty{
                if let dataTask = self?.dataTask {
                    dataTask.cancel()
                }
                self?.fetchAutocompletePlaces(text, textfield: self!.fromTextField)
            }
        }
        
        fromTextField.onSelect = {[weak self] text, indexpath in
            Location.geocodeAddressString(text, completion: { (placemark, error) -> Void in
                if let coordinate = placemark?.location?.coordinate {
                    self?.addAnnotation(coordinate, address: text)
                    self?.mapViewKit.setCenterCoordinate(coordinate, zoomLevel: 12, animated: true)
                }
            })
        }
        
        toTextField.onTextChange = {[weak self] text in
            if !text.isEmpty{
                if let dataTask = self?.dataTask {
                    dataTask.cancel()
                }
                self?.fetchAutocompletePlaces(text, textfield: self!.toTextField)
            }
        }
        
        toTextField.onSelect = {[weak self] text, indexpath in
            Location.geocodeAddressString(text, completion: { (placemark, error) -> Void in
                if let coordinate = placemark?.location?.coordinate {
                    self?.addAnnotation(coordinate, address: text)
                    self?.mapViewKit.setCenterCoordinate(coordinate, zoomLevel: 12, animated: true)
                }
            })
        }

    }
    
    //MARK: - Private Methods
    private func addAnnotation(coordinate:CLLocationCoordinate2D, address:String?){
        if let annotation = selectedPointAnnotation{
            mapViewKit.removeAnnotation(annotation)
        }
        
        selectedPointAnnotation = MKPointAnnotation()
        selectedPointAnnotation!.coordinate = coordinate
        selectedPointAnnotation!.title = address
        mapViewKit.addAnnotation(selectedPointAnnotation!)
    }
    
    private func fetchAutocompletePlaces(keyword:String, textfield: AutoCompleteTextField) {
        let urlString = "\(baseURLString)?key=\(googleMapsKey)&input=\(keyword)"
        let s = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
        s.addCharactersInString("+&")
        if let encodedString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(s) {
            if let url = NSURL(string: encodedString) {
                let request = NSURLRequest(URL: url)
                dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                    if let data = data{
                        
                        do{
                            let result = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                            
                            if let status = result["status"] as? String{
                                if status == "OK"{
                                    if let predictions = result["predictions"] as? NSArray{
                                        var locations = [String]()
                                        for dict in predictions as! [NSDictionary]{
                                            locations.append(dict["description"] as! String)
                                        }
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                            textfield.autoCompleteStrings = locations
                                        })
                                        return
                                    }
                                }
                            }
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                textfield.autoCompleteStrings = nil
                            })
                        }
                        catch let error as NSError{
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                })
                dataTask?.resume()
            }
        }
    }



}

extension HomeViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension HomeViewController : SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(index: Int32, slideMenu: slideMenuView) {

        switch(index){
        case 1:
            
            if self.currentIndex != 1 {
                self.hideMenu()
                self.hideSearch(self)
                self.hidePhone(self)
                
                self.makeRecent()
                
                self.mapViewTrailingConstraint.constant = self.view.frame.size.width
                self.bottomNavTrailingConstraint.constant = self.view.frame.size.width
                self.titleLabel.text = "Recents"
                UIView.animateWithDuration(0.3, animations: {
                    var newViewFrame = self.recentView.frame
                    newViewFrame.origin.x = 0
                    
                    self.recentView.frame = newViewFrame
                    self.currentIndex = 1
                    
                    slideMenu.setSelected(index)
                    
                    self.view.bringSubviewToFront(self.overlayView)
                    self.view.bringSubviewToFront(self.menuView)
                    self.view.layoutIfNeeded()

                    }, completion: { (finished) in
                        self.mapViewTrailingConstraint.constant = 0
                        self.mapViewLeadingConstraint.constant = self.view.frame.size.width
                        self.bottomNavTrailingConstraint.constant = 0
                        self.bottomNavLeadingConstraint.constant = self.view.frame.size.width
                })
            }
        break;
        case 2:
            if self.currentIndex != 2 {
                self.hideMenu()
                self.hideSearch(self)
                self.hidePhone(self)
                
                self.makeBookings()
                
                self.mapViewTrailingConstraint.constant = self.view.frame.size.width
                self.bottomNavTrailingConstraint.constant = self.view.frame.size.width
                self.titleLabel.text = "Bookings"
                UIView.animateWithDuration(0.3, animations: {
                    var newViewFrame = self.bookingView.frame
                    newViewFrame.origin.x = 0
                    
                    self.bookingView.frame = newViewFrame
                    self.currentIndex = 2
                    
                    slideMenu.setSelected(index)
                    
                    self.view.bringSubviewToFront(self.overlayView)
                    self.view.bringSubviewToFront(self.menuView)
                    self.view.layoutIfNeeded()

                    }, completion: { (finished) in
                        self.mapViewTrailingConstraint.constant = 0
                        self.mapViewLeadingConstraint.constant = self.view.frame.size.width
                        self.bottomNavTrailingConstraint.constant = 0
                        self.bottomNavLeadingConstraint.constant = self.view.frame.size.width
                })
            
            }

        break;
        case 3:
            if self.currentIndex != 3 {
                self.hideMenu()
                self.hideSearch(self)
                self.hidePhone(self)
                
                self.makeSettings()
                
                self.mapViewTrailingConstraint.constant = self.view.frame.size.width
                self.bottomNavTrailingConstraint.constant = self.view.frame.size.width
                self.titleLabel.text = "Settings"
                UIView.animateWithDuration(0.3, animations: {
                    var newViewFrame = self.settingView.frame
                    newViewFrame.origin.x = 0
                    
                    self.settingView.frame = newViewFrame
                    self.currentIndex = 3
                    
                    slideMenu.setSelected(index)
                    
                    self.view.bringSubviewToFront(self.overlayView)
                    self.view.bringSubviewToFront(self.menuView)
                    self.view.layoutIfNeeded()

                    }, completion: { (finished) in
                        self.mapViewTrailingConstraint.constant = 0
                        self.mapViewLeadingConstraint.constant = self.view.frame.size.width
                        self.bottomNavTrailingConstraint.constant = 0
                        self.bottomNavLeadingConstraint.constant = self.view.frame.size.width
                })
            }
            
            break;
        case 4:
            if self.currentIndex != 4 {
                self.hideMenu()
                self.hideSearch(self)
                self.hidePhone(self)
                
                self.view.bringSubviewToFront(self.mapView)
                self.view.bringSubviewToFront(self.bottomNavView)
                
                
                self.mapViewLeadingConstraint.constant = 0
                self.bottomNavLeadingConstraint.constant = 0
                self.titleLabel.text = "St Catharines Taxi"

                UIView.animateWithDuration(0.3, animations: {
                    
                    self.currentIndex = 4
                    
                    slideMenu.setSelected(index)
                    
                    self.view.bringSubviewToFront(self.overlayView)
                    self.view.bringSubviewToFront(self.callView)
                    self.view.bringSubviewToFront(self.searchView)
                    self.view.bringSubviewToFront(self.menuView)
                    self.view.layoutIfNeeded()
                })
            }
            
            break;
        default:
        break;
        }
    }
}
