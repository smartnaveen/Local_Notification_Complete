//
//  ViewController.swift
//  Local_Notification_Complete
//
//  Created by Mr. Naveen Kumar on 16/04/21.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    var notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Request authorization succeeded!")
            }else {
                debugPrint("Error - \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    // MARK:- Notification Fired!!
    @IBAction func notificationFiredButtonTapped(_ sender: UIButton) {
        let content = UNMutableNotificationContent()
        content.title = "Hello"
        content.body = "I m fine"
        content.badge = 2
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "notify-test"

        //Add attachment for Notification with more content
        let imageName = "oppsInternet"
        guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "jpg") else { return }
        let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
        content.attachments = [attachment]
        
        
        //Add Action button the Notification
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(identifier: "notify-test",
                                              actions: [snoozeAction, deleteAction],
                                              intentIdentifiers: [],
                                              options: [])
        notificationCenter.setNotificationCategories([category])
        
        //Add Trigger for notification show
        //Use it to define trigger condition
        var date = DateComponents()
        date.calendar = Calendar.current
      //  date.weekday = 5 //5 means Friday
      //  date.hour = 14 //Hour of the day
      // date.minute = 10 //Minute at which it should be sent
        date.second = 3
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

       // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
}

 // MARK:- Notification Delegate method
extension ViewController {
    //Handle Notification Center Delegate methods
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound , .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "SimplifiedIOSNotification" {
            print("Handling notifications with the Local Notification Identifier")
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        completionHandler()
    }
}
