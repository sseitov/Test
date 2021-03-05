//
//  DetailsController.swift
//  Test
//
//  Created by Sergey Seitov on 05.03.2021.
//

import UIKit

class DetailsController: UIViewController, UITableViewDataSource {
    
    var details:NSDictionary?
    var itemName:String?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var table: UITableView!

    var keys:NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self;
        
        name.text = itemName?.uppercased();
        keys = details!.allKeys as NSArray
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
 
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count:Int = keys!.count;
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let key = keys!.object(at: indexPath.row) as! String
        
        cell.textLabel?.text = key
        let text = details?[key] as? String
        if text != nil {
            cell.detailTextLabel?.text = text
            cell.detailTextLabel?.textColor = UIColor.blue
        } else {
            cell.detailTextLabel?.text = "value for this key unavailable"
            cell.detailTextLabel?.textColor = UIColor.lightGray
            cell.textLabel?.textColor = UIColor.lightGray
        }
        
        return cell
    }
}
