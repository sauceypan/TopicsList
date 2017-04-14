//
//  ViewController.swift
//  TopicsList
//
//  Created by Patrick on 4/13/17.
//  Copyright © 2017 Patrick Ngo. All rights reserved.
//

import UIKit

class TopicsListController: UITableViewController, TopicListDelegate
{
    //max number of topics shown - 20
    static var MAX_NUM_TOPICS_SHOWN = 20
    
    
    //in-memory data structure to keep all the topics, using a Swift mutable array
    var topics: [Topic]?

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //create Add Topic navigation button programatically
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Topic", style: .plain, target: self, action: #selector(self.addTopicPressed))
        
        //create array
        self.topics = [Topic]()
    }
    
    
    //when Add Topic button pressed
    func addTopicPressed()
    {
        //launch New Topic screen programatically
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addTopicController = storyboard.instantiateViewController(withIdentifier: "addTopicController") as! AddTopicController
        addTopicController.delegate = self
        self.navigationController?.pushViewController(addTopicController, animated: true)
    }
    
    //sort topics by the count (upvotes - downvotes)
    func sortTopicsByCount()
    {
        topics?.sort(by: { $0.count > $1.count} )
        self.tableView.reloadData()
    }
    
    
    //MARK: - TopicListDelegate
    func addTopic(topic: Topic)
    {
        //add a topic and reload the table
        self.topics?.append(topic)
        self.sortTopicsByCount()
    }
    
    func topicDataChanged()
    {
        //TODO: resort table here
        self.sortTopicsByCount()
    }

    //MARK: - tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let count = topics?.count
        {
            //if less than 20 items, return all items
            if count <= TopicsListController.MAX_NUM_TOPICS_SHOWN
            {
                return count
            }
            //if more than 20 items, only show 20
            else
            {
                return TopicsListController.MAX_NUM_TOPICS_SHOWN
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath) as! TopicCell
        
        //set topic and delegate
        cell.topic = topics?[indexPath.item]
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90
    }

}

