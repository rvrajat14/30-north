//
//  BrewingPage.swift
//  30 NORTH
//
//  Created by SOWJI on 30/03/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit
import UserNotifications
import NotificationCenter
import HGCircularSlider
import fluid_slider
import AVKit

class BrewingPage: UIViewController {

	var notifObserver:NSObjectProtocol?
	var observer: NSKeyValueObservation?

	var data:[CGFloat]? = nil
	var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var pageIndex : Int = 0
    var pageData : ([String],[String],[String],[(Bool,Int,Int,Int,String,Int,Int, Int)],[(Bool,Int,String, String)], [String])? = nil
    var timer: Timer?
    var timerIsOn = false
    var timeRemaining =  45 // Time in seconds
    var totalTime = 45
    var indexProgressBar = 0
    var currentPoseIndex = 0
    var converterType = 1
    var timeWhenEnteringBackground : Int = 0
    var timeWhenEnteringForeground : Int = 0
    var isAppInBakcground : Bool = false

	lazy var player : AVPlayer? =  {
		let player = AVPlayer()
		return player
	}()


	@IBOutlet weak var popupView: UIView!{
		didSet{
			popupView.isHidden = true
			popupView.layer.cornerRadius = CGFloat(8)
			popupView.layer.borderWidth = 1
			popupView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
			popupView.clipsToBounds = true
		}
	}
	@IBOutlet weak var tableView: UITableView! {
		didSet {
			tableView.delegate = self
			tableView.dataSource = self

			tableView.separatorStyle = .none
			tableView.estimatedRowHeight = 30
			tableView.clipsToBounds = true
			tableView.backgroundColor = .black
		}
	}

    @IBOutlet weak var converterWidgetText: UITextView!{
		didSet {
			converterWidgetText.isScrollEnabled = true
			converterWidgetText.isUserInteractionEnabled = true

			converterWidgetText.isEditable = false
			converterWidgetText.isSelectable = false
		}
	}
    @IBOutlet weak var timerWidgetText: UITextView!{
		didSet {
			timerWidgetText.isScrollEnabled = true
			timerWidgetText.isUserInteractionEnabled = true

			timerWidgetText.isEditable = false
			timerWidgetText.isSelectable = false
		}
	}
    @IBOutlet weak var converterFromLabel: UILabel!{
		didSet {
			converterFromLabel.textColor = UIColor.white
			converterFromLabel.font = UIFont(name: AppFontName.bold, size: 16)
		}
	}
    @IBOutlet weak var converterToLabel: UILabel!{
		didSet {
			converterToLabel.textColor = UIColor.white
			converterToLabel.font = UIFont(name: AppFontName.bold, size: 16)
		}
	}
    @IBOutlet weak var scrollview: UIScrollView!
	@IBOutlet weak var lblDescription: UITextView! {
		didSet {
			lblDescription.isScrollEnabled = true
			lblDescription.isUserInteractionEnabled = true
			lblDescription.isEditable = false
			lblDescription.isSelectable = false
		}
	}
    @IBOutlet weak var lblTitle: UITextView!
	@IBOutlet weak var topView: UIView! {
		didSet {
			topView.backgroundColor = .clear
			let playerLayer = AVPlayerLayer(player: self.player)
			playerLayer.frame =  self.topView.frame //bounds of the view in which AVPlayer should be displayed
			playerLayer.contentsCenter = self.topView.frame
			playerLayer.videoGravity = .resizeAspectFill
			topView.layer.addSublayer(playerLayer)
		}
	}
	@IBOutlet weak var pageImage: UIImageView! {
		didSet {
			pageImage.contentMode = .scaleAspectFill
			pageImage.clipsToBounds = true
		}
	}
	@IBOutlet weak var converterView: UIView! {
		didSet {
			converterView.backgroundColor = UIColor.mainViewBackground
			converterView.layer.borderColor = UIColor.clear.cgColor
			converterView.layer.borderWidth = 0
		}
	}
	@IBOutlet weak var timerView: UIView! {
		didSet {
			timerView.backgroundColor = UIColor.mainViewBackground
			timerView.layer.borderColor = UIColor.clear.cgColor
			timerView.layer.borderWidth = 0
		}
	}
	@IBOutlet weak var converterSlider: Slider! {
		didSet {
			converterSlider.isHidden = true
			let converterData = self.pageData!.3[self.pageIndex]
			let MIN = CGFloat(converterData.2)
			let MAX = CGFloat(converterData.3)

			converterSlider.attributedTextForFraction = { fraction in
				let value = MIN + (fraction * (MAX - MIN))
				let formatter = NumberFormatter()
				formatter.maximumIntegerDigits = 3
				formatter.maximumFractionDigits = 0
				let string = formatter.string(from: value as NSNumber) ?? ""
				return NSAttributedString(string: string)
			}

			converterSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
			converterSlider.setMinimumLabelAttributedText(NSAttributedString(string: ""))
			converterSlider.setMaximumLabelAttributedText(NSAttributedString(string: ""))
			converterSlider.fraction = 0
			converterSlider.shadowBlur = 3
			converterSlider.contentViewColor = UIColor.gold
			converterSlider.valueViewColor = .white
            converterSlider.layer.cornerRadius = 3
            converterSlider.contentViewCornerRadius = 3
            //converterSlider.clipsToBounds = true
		}
	}
	@IBOutlet weak var timerLabel: UILabel! {
		didSet {
			timerLabel.textColor = .white
			timerLabel.backgroundColor = .clear
			timerLabel.textAlignment = .center
			timerLabel.numberOfLines = 0
		}
	}
    @IBOutlet weak var yieldsLAbel: UILabel!{
		didSet {
            yieldsLAbel.font = UIFont(name: AppFontName.bold, size: 17)
			yieldsLAbel.textColor = UIColor.white
			yieldsLAbel.layer.cornerRadius = 3.0
			yieldsLAbel.backgroundColor = UIColor.gold
			yieldsLAbel.clipsToBounds = true
			yieldsLAbel.isUserInteractionEnabled = true
		}
	}
	@IBOutlet weak var timerClockView: UIView! {
		didSet {
			timerClockView.backgroundColor = .clear
			timerClockView.clipsToBounds = true
		}
	}
	@IBOutlet weak var gramsLabel: UILabel! {
		didSet {
            gramsLabel.font = UIFont(name: AppFontName.bold, size: 17)
			gramsLabel.textColor = UIColor.white
			gramsLabel.layer.cornerRadius = 3.0
			gramsLabel.backgroundColor = UIColor.gold
			gramsLabel.clipsToBounds = true
			gramsLabel.isUserInteractionEnabled = true

			let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showPopup(_:)))
			gramsLabel.addGestureRecognizer(tapGesture)
		}
	}
	@IBOutlet weak var startButton: UIButton! {
		didSet {
			startButton.layer.cornerRadius = 3.0
            startButton.backgroundColor = UIColor.gold
			startButton.clipsToBounds = true
			startButton.titleLabel?.font = UIFont(name: AppFontName.bold, size: 15)
			startButton.setTitle("Start", for: .normal)
			startButton.setTitleColor(UIColor.white, for: .normal)
		}
	}
	@IBOutlet weak var hoursView:CircularSlider! {
		didSet {
			hoursView.trackFillColor = .white
			hoursView.trackColor = UIColor.gold
			hoursView.diskColor = .clear
			hoursView.thumbRadius = 4
			hoursView.lineWidth = 4
			hoursView.diskFillColor = .clear
			hoursView.endThumbTintColor = .clear
			hoursView.endThumbStrokeColor = .clear
			hoursView.endThumbStrokeHighlightedColor = .clear
		}
	}


	func roundTo(n: Float, mult: Int) -> Int {
		let result: Float = n / Float(mult)
		return Int(result.rounded()) * mult
	}


	@objc func sliderValueChanged(_ sender: UIControl){
        let fractionValue = converterSlider.fraction

        // In my case I use 180 as max value and 10 as min value.
        // You need to change this values to your requirements.
        // My slider goes from 10 to 180 in steps of 5 units.
		let converterData = self.pageData!.3[self.pageIndex]
		let MIN = CGFloat(converterData.2)
		let MAX = CGFloat(converterData.3)
		let step = converterData.7

        let value: Float = Float(fractionValue * (MAX - MIN))
		let resultValue: Int = Int(MIN) + roundTo(n: Float(value), mult: step)
		self.onSliderValue(value: CGFloat(resultValue))

        let nobShadow = NSShadow()
        nobShadow.shadowOffset = .init(width: 0, height: 0)
        let sliderNobLabelAttributes: [NSAttributedString.Key: Any] = [
			.font: UIFont(name: AppFontName.regular, size: 17)!,
            .foregroundColor: #colorLiteral(red: 0.1333333333, green: 0.2196078431, blue: 0.262745098, alpha: 1),
            .shadow: nobShadow
        ]
		let formatter = NumberFormatter()
		formatter.maximumIntegerDigits = 3
		formatter.maximumFractionDigits = 0
		let string = formatter.string(from: resultValue as NSNumber) ?? ""
        let attributedString = NSAttributedString(string: String(string), attributes: sliderNobLabelAttributes)

        converterSlider.attributedTextForFraction = { fractionValue in
            return attributedString
        }
    }
    @objc func appMovedToBackground() {
        self.isAppInBakcground = true
        print("App moved to background with Time Remaining \(self.timeRemaining)")
        self.timeWhenEnteringBackground = Int(Date().timeIntervalSince1970)
        //Let's fire local notification after time remaining
               if(self.timerIsOn == true){
                   if let data = self.pageData {
                    sendNotification(text: data.4[pageIndex].3, afterTime: self.timeRemaining)
                   } else {
                       sendNotification(text: "Your Coffee is ready", afterTime: self.timeRemaining)
                   }
               }

    }
    
    @objc func appMovedToForeground() {
        
        //Remove Brew timer notification here. Because if app is active we do not have to do this.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ["notification.BrewTimer"])

        
        self.isAppInBakcground = false
        self.timeWhenEnteringForeground = Int(Date().timeIntervalSince1970)
        if(self.timerIsOn == true){
            timeRemaining = timeRemaining - (self.timeWhenEnteringForeground - self.timeWhenEnteringBackground)
            print("Time Lapsed in background = \(self.timeWhenEnteringForeground - self.timeWhenEnteringBackground)")
            self.timeWhenEnteringBackground = 0
            self.timeWhenEnteringForeground = 0
        }
            print("App moved to forground with Time Remaining \(self.timeRemaining)")

       }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIApplication.didEnterBackgroundNotification , object: nil)
        notificationCenter.removeObserver(self, name: UIApplication.willEnterForegroundNotification , object: nil)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        self.calculateConverterValues()
        Timer.scheduledTimer(withTimeInterval:2, repeats: false) { timer in
         self.lblDescription.flashScrollIndicators()
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
		self.view.backgroundColor = UIColor.mainViewBackground
        scrollview.contentOffset = CGPoint(x: 0, y: 0)
        self.view.addSubview(self.scrollview)
        self.setSliderContent()
        self.resetTimerData()
        self.configure(pageData!.0[pageIndex], pageData!.1[pageIndex], pageData!.2[pageIndex])
        self.showORHideWidgets(isConverterShown: pageData!.3[pageIndex].0, isTimerShown: pageData!.4[pageIndex].0)
		if pageData!.5.count > pageIndex {
			self.setVideo(url: pageData!.5[pageIndex]/*"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"*/)
		}
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		self.configure(pageData!.0[pageIndex], pageData!.1[pageIndex], pageData!.2[pageIndex])
        self.showORHideWidgets(isConverterShown: pageData!.3[pageIndex].0, isTimerShown: pageData!.4[pageIndex].0)

		//if pageData!.5.count > pageIndex {
			//self.setVideo(url: pageData!.5[pageIndex])
		//}
		self.player?.play()
	}


	

	override func viewWillLayoutSubviews(){
	   super.viewWillLayoutSubviews()
	   //self.scrollview.contentSize  = CGSize(width: self.view.frame.width, height: UIScreen.main.bounds.height > 800 ? UIScreen.main.bounds.height : 800)
	}

	override func viewWillDisappear(_ animated: Bool) {
		resetTimerData()
		self.player?.pause()
	}

	override func didReceiveMemoryWarning() {
	   super.didReceiveMemoryWarning()
	}

	deinit {
		self.player = nil
		self.removeObservers()
		self.notifObserver = nil
	}

    func showORHideWidgets(isConverterShown : Bool,isTimerShown  : Bool) {
        if isConverterShown == true && isTimerShown == false {
            // Showing only Converter Widget by hiding Timer
            self.converterView.isHidden = false
            self.converterView.alpha = 1
            self.timerView.isHidden = true
            self.timerView.alpha = 0
            self.timerWidgetText.text = ""
            self.converterWidgetText.text = pageData!.3[pageIndex].4
        } else if isTimerShown == true && isConverterShown == false {
            self.converterView.isHidden = true
            self.converterView.alpha = 1
            self.timerView.isHidden = false
            self.timerView.alpha = 1
            self.converterWidgetText.text = ""
            self.timerWidgetText.text = pageData!.4[pageIndex].2
        } else {
            self.timerWidgetText.text = ""
            self.converterWidgetText.text = ""
            self.converterView.isHidden = true
            self.converterView.alpha = 0
            self.timerView.isHidden = true
            self.timerView.alpha = 0
        }
    }

	func removeObservers() {

		// Later You Can Remove Observer
		self.observer?.invalidate()
		self.observer = nil

		guard let observer = self.notifObserver else {
			return
		}
		NotificationCenter.default.removeObserver(observer)
	}

	func setVideo(url: String) {

		guard let video = URL(string: url) else {
			return
		}
		let asset = AVAsset(url: video)
		let playerItem = AVPlayerItem(asset: asset)
		self.player?.replaceCurrentItem(with: playerItem)

		//Clean old observers before adding new one.
		self.removeObservers()

		if self.observer == nil {
			self.observer = self.player?.observe(\.status, options:  [.new, .old], changeHandler: { [unowned self] (player, change) in
				if player.status == .readyToPlay {
					player.play()
					self.pageImage.alpha = 0
				} else {
					self.pageImage.alpha = 1
				}
			})
		}
		self.notifObserver = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { [weak self] _ in
			self?.player?.seek(to: CMTime.zero)
			self?.player?.play()
		}
	}

    // Here Converter type 1 is Grams to ML conversion, if other conversions required types can be added.
    // Here we are setting Bottom labels and label minimum values based on converterType
    // Setting slider minimum and maximum values based on the data passed
    func setSliderContent() {
        let converterData = self.pageData!.3[pageIndex]
		let MIN = CGFloat(converterData.2)
		let YLD = CGFloat(converterData.5)
        //let WTR = CGFloat(converterData.5)
		//converterSlider.fraction = MIN
        //YIELD = Int(YLD)
        //YLD = CGFloat(YIELD)
        //print("YLD ",YLD)
		converterSlider.setMinimumLabelAttributedText(NSAttributedString(string: ""))
		converterSlider.setMaximumLabelAttributedText(NSAttributedString(string: ""))
        converterType = converterData.1

        //Setting self.yieldsLabel.text to YLD starts off with zero. It then updates the ML with correct water calculation but doesn't update once the slider is moved
        //Setting self.yieldsLabel.text to WTR starts off with the correct value but doesn't update when slider is moved
        
        switch converterType {
        case 1:
            //Converting from Grams to ml
            //self.converterFromLabel.text = "Grams"
            //self.converterToLabel.text = "ML"
            self.gramsLabel.text = "\(Int(MIN)) g"
            self.yieldsLAbel.text = "\(Int(YLD)) ml"
        case 2:
            //Converting from Grams to oz
            //self.converterFromLabel.text = "Grams"
            //self.converterToLabel.text = "OZ"
            self.gramsLabel.text = "\(Int(MIN)) g"
            self.yieldsLAbel.text = "\(Int(MIN)) oz"
        default:
            //self.converterFromLabel.text = "Grams"
            //self.converterToLabel.text = "ML"
            self.gramsLabel.text = "\(Int(MIN)) g"
            self.yieldsLAbel.text = "\(Int(YLD)) ml"
        }
        self.converterFromLabel.text = "(1 CUP)"
        self.converterToLabel.text = "WATER"
    }
    
    // Logic when slider is moving based on converter Type
	func onSliderValue(value:CGFloat) {
        print("Slider Value \(value)")
        let converterData = self.pageData!.3[pageIndex]
        let MIN = CGFloat(converterData.2)
        let numberOfCups = Int(value/MIN)
        
        let MLT = Float(converterData.6)
		guard self.gramsLabel != nil, self.yieldsLAbel != nil else {
			return
		}
        let sliderVal = roundf(Float(value))
        switch converterType {
        case 1:
            //Converting from Grams to ml
            self.gramsLabel.text = Int(sliderVal).description + " g"
            self.yieldsLAbel.text = Int(sliderVal*MLT).description + " ml"
        case 2:
            //Converting from Grams to oz
            self.gramsLabel.text = Int(sliderVal).description + " g"
            self.yieldsLAbel.text = Int(sliderVal/1.75).description + " oz"
        default:
            self.gramsLabel.text = Int(sliderVal).description + " g"
            self.yieldsLAbel.text = Int(sliderVal*MLT).description + " ml"
        }
        
        if(numberOfCups == 1){
        self.converterFromLabel.text = "(" + String(numberOfCups) + " CUP)"
        }else{
            self.converterFromLabel.text = "(" + String(numberOfCups) + " CUPS)"
        }
        YIELD = Int((sliderVal*MLT))
        YIELD2 = Int((sliderVal*MLT))
        //YIELD12P5 = (YIELD*Int((12.5)))/100
        YIELD12P5 = Int(Float(YIELD)*12.5)/100
        YIELDRM1 = YIELD-Int(Float(YIELD)*12.5)/100
        YIELDRM2 = YIELD-Int(Float(YIELD)*12.5)/100

        //setSliderContent()
    }
    
    func resetTimerData() {
        if self.pageData!.4[pageIndex].0 == true {
            let timeData = self.pageData!.4[pageIndex].1
            timeRemaining = timeData
            totalTime = timeData
            let minutes = Int(timeRemaining) / 60 % 60
            let seconds = Int(timeRemaining) % 60
            timerLabel.text = String(format: "%02d", minutes) + " : " + String(format: "%02d", seconds)
        }
        self.timerIsOn = false
		startButton.setTitle("Start", for: .normal)

        //timerProgress.progress = 0.0
		self.hoursView.endPointValue = 0.0
        if timer != nil{
            timer!.invalidate()
        }
        timer = nil
    }

    func configure(_ title : String , _ desc : String ,_ image : String) {
		var updatedDesc = desc.replacingOccurrences(of: "__(YIELD2)__", with: "\(YIELD2*10)")
        //OR
         updatedDesc = updatedDesc.replacingOccurrences(of: "__(YIELD2P)__", with: "\((YIELD*20)/100)")
        //OR
        updatedDesc = updatedDesc.replacingOccurrences(of: "__(YIELD)__", with: "\(YIELD)")
        //OR
        updatedDesc = updatedDesc.replacingOccurrences(of: "__(YIELD12P5)__", with: "\(YIELD12P5)")
        //OR
        updatedDesc = updatedDesc.replacingOccurrences(of: "__(YIELDRM1)__", with: "\(YIELDRM1)")
        //OR
        updatedDesc = updatedDesc.replacingOccurrences(of: "__(YIELDRM2)__", with: "\(YIELDRM2)")

        self.lblDescription.text = updatedDesc//self.pageData!.1[pageIndex]
        self.lblTitle.text = title//self.pageData!.0[pageIndex]
        self.lblTitle.font = UIFont(name: AppFontName.nexaBlack, size: 20)
		if image.hasPrefix("http") {
			self.pageImage.loadImage(urlString: image) { (status, url, image, msg) in
				print(msg)
			}
		} else {
			self.pageImage.image = UIImage(named: image)
		}
		self.setDescriptionHeight()

		lblDescription.sizeToFit()
		timerWidgetText.sizeToFit()
		converterWidgetText.sizeToFit()
    }


	func setDescriptionHeight() {
		let descHeightConstraint = self.lblDescription.constraints.first { (constraint) -> Bool in
			return constraint.identifier == "DescHeightConstraint"
		}
		if UIDevice.current.userInterfaceIdiom == .phone {
			let screenBounds = UIScreen.main.bounds
			if screenBounds.height <= 667 { // small devices like SE
				descHeightConstraint?.constant = 112
			} else if screenBounds.height <= 736 { // 8 Plus case
				descHeightConstraint?.constant = 150
			} else if screenBounds.height <= 812 { // 11 pro case
				descHeightConstraint?.constant = 180
			} else {
				descHeightConstraint?.constant = 200
			}
		}
	}

    @IBAction func startTimer(_ sender: UIButton) {
        if !timerIsOn {
            sender.setTitle("Reset", for: .normal)
            self.timerIsOn = true
            self.beginBackgroundTask()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
        } else {
            sender.setTitle("Start", for: .normal)
            timer!.invalidate()
            resetTimerData()
        }
    }
    
    func letsStartTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)

    }
    
    
    func beginBackgroundTask() {
        
        self.backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            //self.letsStartTimer()

            // you can't call endBackgroundTask here and you don't need to
           //print("beginBackgroundTask")
        })
        assert(self.backgroundTask != UIBackgroundTaskIdentifier.invalid)
    }

    func endBackgroundTask() {
        if self.backgroundTask != nil {
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskIdentifier.invalid
        }
    }
    
    func getNextPoseData() {
        // do next pose stuff
        currentPoseIndex += 1
       //print(currentPoseIndex)
    }

    @objc func setProgress() {
        
        if(self.isAppInBakcground == true){
            return
        }
        
        
        if(timeRemaining > -1){
        timeRemaining -= 1
        }
        
       
        
        let completionPercentage = Int(((Float(totalTime) - Float(timeRemaining))/Float(totalTime)) * 100)
        print ("Completion percentage \(completionPercentage) \n")
        if completionPercentage <= 100 {
            //timerProgress.setProgress(((Float(totalTime) - Float(timeRemaining))/Float(totalTime)), animated: false)
			let elapsedTime = Float(totalTime - timeRemaining)
			hoursView.endPointValue = CGFloat((Float(totalTime) - elapsedTime)/Float(totalTime))
            let minutesLeft = Int(timeRemaining) / 60 % 60
            let secondsLeft = Int(timeRemaining) % 60
            timerLabel.text = String(format: "%02d", minutesLeft) + " : " + String(format: "%02d", secondsLeft)
            if completionPercentage == 100 {
				timerIsOn = false
				startButton.setTitle("Start", for: .normal)
                _ =  SweetAlert().showAlert("30 NORTH", subTitle: "Brewing is complete", style: AlertStyle.customImag(imageFile: "Logo"))
				if let data = self.pageData {
					sendNotification(text: data.4[pageIndex].3, afterTime: 1)
				} else {
                    sendNotification(text: "Your Coffee is ready", afterTime: 1)
				}

            }
        } else {
            timer!.invalidate()
            timer = nil
            if self.pageData!.4[pageIndex].0 == true {
                let timeData = self.pageData!.4[pageIndex].1
                timeRemaining = timeData
                totalTime = timeData
                let minutes = Int(timeRemaining) / 60 % 60
                let seconds = Int(timeRemaining) % 60
                timerLabel.text = String(format: "%02d", minutes) + " : " + String(format: "%02d", seconds)
                self.resetTimerData()
            }
        }
    }
    
    func sendNotification(text:String = "Your Coffee is ready", afterTime: Int) {
        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                   if granted == true {
                    print("Scheduling user notification now")
                           let content = UNMutableNotificationContent()
                           content.title = "30 NORTH"
                           content.subtitle = ""
                           content.body = text
                           content.sound = .default
                           //content.categoryIdentifier = "CoffeeTimer"
                           // 2
                           let imageName = "App-Launch-Icon-RT"
                           guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else { return }
                           
                           let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
                           
                           content.attachments = [attachment]
                           
                           // 3
                           let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(afterTime), repeats: false)
                           let request = UNNotificationRequest(identifier: "notification.BrewTimer", content: content, trigger: trigger)
                           
                           // 4
                           UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                   }else{
                    print("Error \(String(describing: error))")
            }
            
        }
    }
}

extension BrewingPage {

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		dismissPopup()
	}

	func dismissPopup() {
		self.popupView.isHidden = true
		self.data = nil
	}
}

extension BrewingPage : UITableViewDelegate, UITableViewDataSource {

	@objc func showPopup(_ sender:UITapGestureRecognizer) {
		self.calculateConverterValues()

		popupView.isHidden = false
		self.view.bringSubviewToFront(popupView)
		tableView.reloadData()

		let tableViewHeightConstraint = tableView.constraints.first { (constraint) -> Bool in
			return constraint.identifier == "TableViewHeightConstraint"
		}
		tableViewHeightConstraint?.constant = 200
	}

	func calculateConverterValues() {
		if pageData!.3[pageIndex].0 {
			let converterData = self.pageData!.3[self.pageIndex]
			let MIN = CGFloat(converterData.2)
			let MAX = CGFloat(converterData.3)
			let STEP = CGFloat(converterData.7)

			self.data = []
			for index in stride(from: MIN, through: MAX, by: STEP) {
				self.data?.append(index)
			}
		}
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let count = self.data?.count else {
			return 0
		}
		return count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:UITableViewCell = {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
				return UITableViewCell(style: .default, reuseIdentifier: "Cell")
			}
			return cell
		}()

		guard let value = self.data?[indexPath.row] else {
			return cell
		}

		cell.textLabel?.textColor = .white
		cell.textLabel?.font = UIFont(name: AppFontName.bold, size: 18)
		cell.textLabel?.textAlignment = .center

		cell.textLabel?.text = "\(Int(value)) g"
		cell.selectionStyle = .none
		cell.backgroundColor = .clear
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		guard let value = self.data?[indexPath.row] else {
			return
		}
		self.gramsLabel.text = "\(value) g"
		self.onSliderValue(value: value)

		dismissPopup()
	}
}
