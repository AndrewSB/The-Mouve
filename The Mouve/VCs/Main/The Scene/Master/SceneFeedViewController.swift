//
//  SceneFeedViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/8/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

let fakeData = [Event(name: "Beach Chillin", about: "Bring your swim suits! We will be chilling at the Lincoln Park Beach", time: NSDate(), length: 0, addressString: "Lincoln Beach", invitees: [43,43,43,43,43,43,4,3,4,343,43,34].map({"\($0)"}), backgroundImage: UIImage(named: "Beach-Chillin")!), Event(name: "Coffee Hour", about: "Let’s grab cup of coffee and discuss about fun things!", time: NSDate(), length: 3, addressString: "Cafe Kopi", invitees: [43,43,43,43,43,43,4,3,4,343,43,34].map({"\($0)"}), backgroundImage: UIImage(named: "Coffee-Hour")!), Event(name: "Espresso Lesson", about: "We will teach you how to brew coffee! It is $5 per person. Cash Only!", time: NSDate(), length: 4, addressString: "1005 W Gregory Dr.", invitees: ["dsad","dsad","dsad","dsad","dsad","dsad","dsad","dsad","dsad","dsad",], backgroundImage: UIImage(named: "Espresso-Lesson")!), Event(name: "Fireworks", about: "$8 entry fee. Come and have fun with fire!", time: NSDate(), length: 3, addressString: "Navy pier", invitees: [43,43,43,43,43,43,4,3,4,343,43,34].map({"\($0)"}), backgroundImage: UIImage(named: "Fire-Works")!), Event(name: "Food Festival", about: " Do you like food trucks? There will be a lots of them here! Come and eat our foods!", time: NSDate(), length: 3, addressString: "Green street", invitees: [43,43,43,43,43,43,4,3,4,343,43,34].map({"\($0)"}), backgroundImage: UIImage(named: "Food-Festival")!), Event(name: "Football game", about: "Bears and Bangles game. Come and support our team!", time: NSDate(), length: 3, addressString: "Memorial stadium", invitees: [43,43,43,43,43,43,4,3,4,343,43,34].map({"\($0)"}), backgroundImage: UIImage(named: "Football-Game")!), Event(name: "Internapalooza", about: " $8 entry fee. Bring your friends and family to celebrate our anniversary!", time: NSDate(), length: 3, addressString: "Siebel Center", invitees: [43,43,43,43,43,43,4,3,4,343,43,34].map({"\($0)"}), backgroundImage: UIImage(named: "Football-Game")!), Event(name: "Internapalooza", about: "hang out with people that are intending at san francisco over the summer! ", time: NSDate(), length: 3, addressString: "Siebel Center", invitees: [43,43,43,43,43,43,4,3,4,343,43,34].map({"\($0)"}), backgroundImage: UIImage(named: "San-Francisco-Visit")!), Event(name: "State Fair", about: "$5 entry fee.", time: NSDate(), length: 3, addressString: "Siebel Center", invitees: [43,43,43,43,43,43,4,3,4,343,43,34].map({"\($0)"}), backgroundImage: UIImage(named: "State-Fair")!), Event(name: "Surfing Lesson", about: "$30 fee per person. It will be 4 hours long at the beach.", time: NSDate(), length: 3, addressString: "Navy Pier", invitees: [43,43,43,43,43,43,4,3,4,343,43,34].map({"\($0)"}), backgroundImage: UIImage(named: "Surf-Lesson")!)]

class SceneFeedViewController: UIViewController {
    var type: SceneType!
    @IBOutlet weak var feedTableView: UITableView!
    
    var feedData: [Event]? {
        didSet {
            feedTableView.reloadData()
        }
    }
    
    convenience init(type: SceneType) {
        self.init()
        self.type = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        feedData = fakeData
        
        feedTableView.contentInset = UIEdgeInsets(top: 44+22, left: 0, bottom: 44, right: 0)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        LocalMessage.post(type.hashValue == 0 ? .HomeFeedPageTwo : .HomeFeedPageOne)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if let des = segue.destinationViewController as? DetailViewController {
            des.event = sender as! Event
        }
    }
    
    @IBAction func unwindToTutorialVC(segue: UIStoryboardSegue) {}
}



extension SceneFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return feedData == nil ? 0 : feedData!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID") as! HomeEventTableViewCell
        
        cell.event = feedData![indexPath.section]
        
        return cell
    }
    
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        performSegueWithIdentifier("segueToDetail", sender: feedData![indexPath.section])
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 4
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}