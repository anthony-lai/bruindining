//
//  FirstViewController.swift
//  BruinDining
//
//  Created by Anthony Lai on 1/14/17.
//  Copyright © 2017 Anthony Lai. All rights reserved.
//

import UIKit
import Kanna

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    /// The summary chat objects
//    var FoodObjects = [FoodObject]()
    var stationObjects = [StationObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        self.tableView.contentInset = UIEdgeInsetsMake(UIApplication.shared.statusBarFrame.size.height, 0.0, 0.0, 0.0)
//        self.edgesForExtendedLayout = UIRectEdge
//        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(UIApplication.shared.statusBarFrame.size.height, 0.0, 0.0, 0.0)
//        self.extendedLayoutIncludesOpaqueBars = false
//        self.automaticallyAdjustsScrollViewInsets = false
        
        
        let myURLString = "http://menu.dining.ucla.edu/Menus/Today/Dinner"
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return
        }
        
        do {
            let rawHTML = try String(contentsOf: myURL, encoding: .ascii)
            sz(html: rawHTML)
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    func sz(html: String) {
        if let doc = HTML(html: html, encoding: .utf8) {
            for diningHall in doc.css("div[class^='menu-block third-col']") {
                analyze(diningHall: diningHall)
            }
            for diningHall in doc.css("div[class^='menu-block half-col']") {
                analyze(diningHall: diningHall)
            }
        }
    }
    
    func analyze(diningHall: XMLElement) {
        if let diningHallDoc = HTML(html: diningHall.toHTML!, encoding: .utf8) {
            let diningHallName = diningHallDoc.css("h3[class^='col-header']")[0]
            print(diningHallName.text!)
            for station in diningHallDoc.css("li[class^='sect-item']") {
                if let stationDoc = HTML(html: station.toHTML!, encoding: .utf8) {
                    let newlineChars = CharacterSet.newlines
                    let lineArray = station.text!.components(separatedBy: newlineChars).filter{!$0.isEmpty}
                    let stationRaw = lineArray[0]
                    let stationPrintable = stationRaw.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    print(stationPrintable)
                    print("---")
                    var foodObjects = [FoodObject]()
                    for menuItem in stationDoc.css("span[class^='tooltip-target-wrapper']") {
                        let menuItemDoc = HTML(html: menuItem.toHTML!, encoding: .utf8)!
                        let foodItem = menuItemDoc.css("a[class^='recipelink']")[0]
                        print(foodItem.text!)
                        var allergens = [String]()
                        for webcode in menuItemDoc.css("img[class^='webcode']") {
                            allergens.append(webcode["alt"]!.lowercased())
                        }
                        foodObjects.append(FoodObject(name: foodItem.text!, allergens: allergens))
                    }
                    stationObjects.append(StationObject(name: stationPrintable, foodObjects: foodObjects))
                }
            }
            print(" ")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return stationObjects.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationObjects[section].foodObjects.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath as IndexPath) as! FoodCell
        cell.Name.text = stationObjects[indexPath.section].foodObjects[indexPath.row].name
        let allergens = stationObjects[indexPath.section].foodObjects[indexPath.row].allergens
        switch allergens.count {
        case 5:
            cell.a.image = UIImage(named: "\(allergens[0]).png")
            cell.b.image = UIImage(named: "\(allergens[1]).png")
            cell.c.image = UIImage(named: "\(allergens[2]).png")
            cell.d.image = UIImage(named: "\(allergens[3]).png")
            cell.e.image = UIImage(named: "\(allergens[4]).png")
        case 4:
            cell.a.image = nil
            cell.b.image = UIImage(named: "\(allergens[0]).png")
            cell.c.image = UIImage(named: "\(allergens[1]).png")
            cell.d.image = UIImage(named: "\(allergens[2]).png")
            cell.e.image = UIImage(named: "\(allergens[3]).png")
        case 3:
            cell.a.image = nil
            cell.b.image = nil
            cell.c.image = UIImage(named: "\(allergens[0]).png")
            cell.d.image = UIImage(named: "\(allergens[1]).png")
            cell.e.image = UIImage(named: "\(allergens[2]).png")
        case 2:
            cell.a.image = nil
            cell.b.image = nil
            cell.c.image = nil
            cell.d.image = UIImage(named: "\(allergens[0]).png")
            cell.e.image = UIImage(named: "\(allergens[1]).png")
        case 1:
            cell.a.image = nil
            cell.b.image = nil
            cell.c.image = nil
            cell.d.image = nil
            cell.e.image = UIImage(named: "\(allergens[0]).png")
        default:
            break
        }
        return cell
     }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return stationObjects[section].name
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    /// Prepares for a segue when a chat is tapped
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
////        if segue.identifier == "chatTapped" {
////            let singleChatTableViewController = segue.destinationViewController as! SingleChatTableViewController
////            singleChatTableViewController.chatId = Database.getString(chatObjects[tableView.indexPathForSelectedRow!.row], field: DString.sumChatClass.actualChatObjectID)!
////            singleChatTableViewController.summaryChat = chatObjects[tableView.indexPathForSelectedRow!.row]
////        }
//    }
//    
//    @IBAction func goBack(segue: UIStoryboardSegue) {
//    }


}

