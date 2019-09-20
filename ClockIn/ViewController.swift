//
//  ViewController.swift
//  ClockIn
//
//  Created by Arief Shaifullah Akbar on 17/09/19.
//  Copyright © 2019 Arief Shaifullah Akbar. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
import LocalAuthentication

class ViewController: UIViewController, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {

    let locationManager: CLLocationManager = CLLocationManager()
    var switcher = 0
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8744233251, green: 0.8745703101, blue: 0.8744040132, alpha: 1)
        
        view.addSubview(welcomeLabel)
        welcomeLabel.setAnchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 80, paddingLeft: 16)
        
        view.addSubview(nameLabel)
        nameLabel.setAnchor(top: welcomeLabel.bottomAnchor, left: view.leftAnchor, paddingLeft: 16)
        
        view.addSubview(timeLabel)
        timeLabel.setAnchor(centerY: view.centerYAnchor, centerX: view.centerXAnchor)
        
        view.addSubview(clockBody)
        clockBody.setAnchor(centerY: view.centerYAnchor, centerX: view.centerXAnchor, width: 200, height: 200)
//        clockBody.isEnabled = false
        
        view.addSubview(clockIndicator)
        
        let degree = calculateDegree()

        let startAngle: CGFloat = CGFloat(degree) + -0.25 * 2 * .pi
        let endAngle: CGFloat = startAngle + 2 * .pi
        
        let circlePath = UIBezierPath(arcCenter: self.view.center, radius: 100, startAngle: startAngle , endAngle: endAngle, clockwise: true)
        clockIndicator.setAnchor(width: 12, height: 12)
        
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation.duration = 43200
        animation.repeatCount = MAXFLOAT
        animation.path = circlePath.cgPath
        
        // You can also pass any unique string value for key
        clockIndicator.layer.add(animation, forKey: nil)
        
        
        
        
        
        view.addSubview(infoLabel)
        infoLabel.setAnchor(centerX: view.centerXAnchor, top: timeLabel.bottomAnchor)
        
        return view
    }()
    
    func calculateDegree(_ date: Date = Date()) -> CGFloat{
        let hour = DateFormatter()
        let minute = DateFormatter()
        
        hour.dateFormat = "h"
        minute.dateFormat = "m"
        
        let hourString = "\(hour.string(from: date))"
        let minuteString = "\(minute.string(from: date))"
        
        // hour: 360 / 12 * waktuSekarang ;  minute: 60 menit / 30 derajat
        let degree = (360 / 12 * Double(hourString)! + (0.5 * Double(minuteString)!)) * .pi / 180
        
        print("date:",  date)
        print("hour: \(hourString):\(minuteString), degree: \(degree)")
        print(0.0166666667 * Double(minuteString)!)
        
        return CGFloat(degree)
    }
    
    let clockBody: UIButton = {
        var button = UIButton()
        
        button.clipsToBounds = true
        
        button.layer.borderColor = #colorLiteral(red: 0.1215686277, green: 0.1294117719, blue: 0.1411764771, alpha: 1)
        button.layer.borderWidth = 1.0
        button.layer.backgroundColor = .none
        button.layer.cornerRadius = 100
        
        button.addTarget(self, action: #selector(handleMessageUser), for: .touchUpInside)
        
        
        return button
    }()
    
    let clockIndicator: UIView = {
        var circleView = UIView()
        
        circleView.clipsToBounds = true
        circleView.layer.backgroundColor = #colorLiteral(red: 0.1215686277, green: 0.1294117719, blue: 0.1411764771, alpha: 1)
        circleView.layer.cornerRadius = 6
        circleView.layer.masksToBounds = false
        circleView.layer.shadowOffset = .zero
        circleView.layer.shadowRadius = 3
        circleView.layer.shadowOpacity = 0.2
        
        return circleView
    }()
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "welcome,"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Arief Shaifullah Akbar"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = #colorLiteral(red: 0.172595799, green: 0.1715767086, blue: 0.1733835936, alpha: 1)
        return label
    }()
    
    let timeLabel: UILabel = {
        var dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH:mm"
        
        var timeString = "\(dateFormatter.string(from: Date()))"
        
        let label = UILabel()
        label.textAlignment = .center
        label.text = timeString
        label.font = UIFont.boldSystemFont(ofSize: 38)
        
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Tap to clock-in!"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = #colorLiteral(red: 0.172595799, green: 0.1715767086, blue: 0.1733835936, alpha: 1)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(containerView)
        containerView.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        requestPermissionNotifications()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        // trigger 100 meter dari academy
        locationManager.distanceFilter = 100
        
        let geofenceRegion: CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(-6.302128, 106.652364), radius: 100, identifier: "Apple Developer Academy @BINUS")
        
        locationManager.startMonitoring(for: geofenceRegion)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for currentLocation in locations {
            print("\(String(describing: index)): \(currentLocation)")
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered \(region.identifier)")
        postLocalNotifications(eventTitle: "\(region.identifier)", eventBody: "Don't forget to clock in!")
        clockBody.isEnabled = true
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited \(region.identifier)")
        
        if switcher != 2 {
            postLocalNotifications(eventTitle: "You forgot to clock out", eventBody: "Please head back to the Academy and clock yourself out!")
        }

    }
    
    
    
    func requestPermissionNotifications(){
        let application =  UIApplication.shared
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (isAuthorized, error) in
                if( error != nil ){
                    print(error!)
                }
                else{
                    if( isAuthorized ){
                        print("authorized")
                        NotificationCenter.default.post(Notification(name: Notification.Name("AUTHORIZED")))
                    }
                    else{
                        let pushPreference = UserDefaults.standard.bool(forKey: "PREF_PUSH_NOTIFICATIONS")
                        if pushPreference == false {
                            let alert = UIAlertController(title: "Turn on Notifications", message: "Push notifications are turned off.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Turn on notifications", style: .default, handler: { (alertAction) in
                                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                                    return
                                }
                                
                                if UIApplication.shared.canOpenURL(settingsUrl) {
                                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                        // Checking for setting is opened or not
                                        print("Setting is opened: \(success)")
                                    })
                                }
                                UserDefaults.standard.set(true, forKey: "PREF_PUSH_NOTIFICATIONS")
                            }))
                            alert.addAction(UIAlertAction(title: "No thanks.", style: .default, handler: { (actionAlert) in
                                print("user denied")
                                UserDefaults.standard.set(true, forKey: "PREF_PUSH_NOTIFICATIONS")
                            }))
                            let viewController = UIApplication.shared.keyWindow!.rootViewController
                            DispatchQueue.main.async {
                                viewController?.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
        else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }
    
    func postLocalNotifications(eventTitle:String, eventBody: String){
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = eventTitle
        content.body = eventBody
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        
        let notificationRequest:UNNotificationRequest = UNNotificationRequest(identifier: "Region", content: content, trigger: trigger)
        
        center.add(notificationRequest, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
                print(error)
            }
            else{
                print("added")
            }
        })
    }
    
    @objc func handleMessageUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success{
                        if self?.switcher == 0 {
                            self?.infoLabel.text = "Tap to Clock Out"
                            self?.switcher = 1
                        } else {
                            self?.infoLabel.text = "See you tomorrow!🚀"
                            self?.clockBody.isEnabled = false
                            self?.switcher = 2
                        }
                        
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified, please try again!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            // no biometry
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
    }
    
    
}

