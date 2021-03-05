//
//  ViewController.swift
//  Test
//
//  Created by Sergey Seitov on 24.02.2021.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var table: UITableView!

    
    let loginList : NSMutableArray = NSMutableArray()
    let loginParam : NSMutableDictionary = NSMutableDictionary()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        progress.isHidden = true;
        
    }
    
    func getData() {
        
        let urlPath: String = "https://api.github.com/users"
        let url: NSURL = NSURL(string: urlPath)!
        let request1: NSURLRequest = NSURLRequest(url: url as URL)
        let queue:OperationQueue = OperationQueue()

        
        progress.isHidden = false;
        progress.startAnimating();

        NSURLConnection.sendAsynchronousRequest(request1 as URLRequest, queue: queue, completionHandler: { (response: URLResponse?, data: Data?, error: Error?) -> Void in


                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSArray {
                        for item in jsonResult {
                            if let dictItem = item as? NSDictionary {
                                let login:String = dictItem["login"] as! String
                                self.loginParam[login] = dictItem
                                self.loginList.add(dictItem["login"] ?? "unkown")
                            }
                        }
                        DispatchQueue.main.async {
                            self.table.isHidden = false
                            self.progress.isHidden = true;
                            self.table.reloadData()
                        }
                    } else {
                        print("other")
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            })

    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        sender.isEnabled = false;
        sender.isHidden = true;
        progress.isHidden = false;
        progress.startAnimating();

        getData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.isHidden = true
        table.dataSource = self
        table.delegate = self
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loginList.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = loginList.object(at: indexPath.row) as? String
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        let sectionName: String
        switch section {
            case 0:
                sectionName = NSLocalizedString("GitHub User List", comment: "User List")
            default:
                sectionName = ""
        }
        return sectionName
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = loginList.object(at: indexPath.row)
        performSegue(withIdentifier: "showDetail", sender: item)
        
        tableView.deselectRow(at:indexPath, animated: true);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetail") {

            if let vc: DetailsController = segue.destination as? DetailsController {
                let name:String = sender as? String ?? "";
                vc.itemName = name;
                vc.details = loginParam[name] as? NSDictionary;
            }

        }
    }
}

