//
//  ViewController.swift
//  MakeSchoolHelpQueue
//
//  Created by Tyler Weitzman on 6/25/15.
//  Copyright (c) 2015 Tyler Weitzman. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    var timer: NSTimer?
    var refreshTask : UIBackgroundTaskIdentifier?
    var refreshTask2 : UIBackgroundTaskIdentifier?
    var refreshCount = 1
    var requests = [Request]()
    var location = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Dojs any additional setup after loading the view, typically from a nib.
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://makeschool.com/sa/admin")!));
        timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        webView.delegate = self
        requestBackground()
//        println("Rabbit")
//        NSTimer.scheduledTimerWithTimeInterval(60*2, target: self, selector: Selector("refreshBackground"), userInfo: nil, repeats: true)
        location.requestAlwaysAuthorization()
        location.requestWhenInUseAuthorization()
//        location.reque
//        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyBest
        location.startUpdatingLocation()

    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        println("Monkey")
    }
    func refreshBackground() {
        location.startUpdatingLocation()
        location.stopUpdatingLocation()
        /*
        if refreshCount==1 {
//            requestBackground2()
            UIApplication.sharedApplication().endBackgroundTask(refreshTask!)
            refreshCount = 2
        } else {
            requestBackground()
            UIApplication.sharedApplication().endBackgroundTask(refreshTask2!)
            refreshCount = 1
        }*/
    }
    func requestBackground() {
        println("Attempting to start background task 1")
        self.refreshTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
            
            println("Ending background task 1")
            var localNotification = UILocalNotification()
            localNotification.alertAction = "view"
            localNotification.alertBody = "Background task 1 ended."
            localNotification.soundName = UILocalNotificationDefaultSoundName
//            self.requestBackground2()
            //                    localNotification.alertLaunchImage =
            
            UIApplication.sharedApplication().presentLocalNotificationNow(localNotification)
            UIApplication.sharedApplication().endBackgroundTask(self.refreshTask!)
            
        }
       /* if refreshTask!==UIBackgroundTaskInvalid {
            var localNotification = UILocalNotification()
            localNotification.alertAction = "view"
            localNotification.alertBody = "Background task 1 started with \(UIApplication.sharedApplication().backgroundTimeRemaining)."
            localNotification.soundName = UILocalNotificationDefaultSoundName
            //            self.requestBackground()
            //                    localNotification.alertLaunchImage =
            
            UIApplication.sharedApplication().presentLocalNotificationNow(localNotification)
        }*/

    }
    func requestBackground2() {
        println("Attempting to start background task 2")
        self.refreshTask2 = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
            
            println("Ending background task 2")
            var localNotification = UILocalNotification()
            localNotification.alertAction = "view"
            localNotification.alertBody = "Background task 2 ended."
            localNotification.soundName = UILocalNotificationDefaultSoundName
//            self.requestBackground()
            //                    localNotification.alertLaunchImage =
            
            UIApplication.sharedApplication().presentLocalNotificationNow(localNotification)
            UIApplication.sharedApplication().endBackgroundTask(self.refreshTask2!)
            
        }
        if refreshTask2!==UIBackgroundTaskInvalid {
            var localNotification = UILocalNotification()
            localNotification.alertAction = "view"
            localNotification.alertBody = "Background task 2 started with \(UIApplication.sharedApplication().backgroundTimeRemaining)."
            localNotification.soundName = UILocalNotificationDefaultSoundName
            //            self.requestBackground()
            //                    localNotification.alertLaunchImage =
            
            UIApplication.sharedApplication().presentLocalNotificationNow(localNotification)
        }
        
    }

    func update() {

        var pathname = webView.stringByEvaluatingJavaScriptFromString("window.location.pathname")
        println("Update path: \(pathname)")
        if pathname == "/login" {
        webView.stringByEvaluatingJavaScriptFromString("document.forms[0].elements[2].value = 'tyler.weitzman@makeschool.com'")
        webView.stringByEvaluatingJavaScriptFromString("document.forms[0].elements[3].value=''")
        webView.stringByEvaluatingJavaScriptFromString("document.forms[0].elements[5].click()")


        } else {
            webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://makeschool.com/sa/admin")!));
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController : UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {

        var pathname = webView.stringByEvaluatingJavaScriptFromString("window.location.pathname")
        println("Delegate path: \(pathname)")
        if pathname == "/login" {
            println("call update")
            self.update();

        } else if pathname == "/sa/admin" {
//                println(webView.stringByEvaluatingJavaScriptFromString("document.body.innerHTML"))
            NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("finishLoading"), userInfo:nil, repeats: false)
            
        }

            /*
            if true {

            }*/
        
    
//        webView.delegate = nil
    }
    
    func finishLoading() {
        self.webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('col-three-fifths mt0 mb0')[0].style.display = 'none'")
        var studentCount = self.webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('event-author-wrap mb2').length")?.toInt()
        println(studentCount)
        for var i = 0; i < studentCount; i++ {
            var studentName = self.webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('event-author-wrap mb2')[\(i)].getElementsByTagName('span')[0].innerHTML")
            //                println(studentName)
            var studentQuestion = self.webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('event-content pt2 mb2')[\(i)].getElementsByTagName('span')[0].getElementsByTagName('p')[0].innerHTML")
            //                println(studentQuestion)
            if let n = studentName, let q = studentQuestion {
                var r = Request(name: n, question: q)
                var contains = false
                for x in requests {
                    if x==r {
                        contains = true
                    }
                }
                if(!contains) {
                    println("Added request")
                    println(r)
                    requests.append(r)
                    var localNotification = UILocalNotification()
                    localNotification.alertAction = "Needs Help"
                    localNotification.alertBody = "\(n): \(q)"
//                    localNotification.alertLaunchImage = 
                    localNotification.soundName = UILocalNotificationDefaultSoundName

                    UIApplication.sharedApplication().presentLocalNotificationNow(localNotification)
                }
            }
        }

    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        println(error.description)
    }

}


