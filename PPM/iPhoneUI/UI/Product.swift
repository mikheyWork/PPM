//
//  Product.swift
//  WP.m.1
//
//  Created by softevol on 9/10/18.
//  Copyright © 2018 softevol. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MYTableViewIndex

class Product: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewIndexDataSource, TableViewIndexDelegate  {
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewIndex: TableViewIndex!
    
    var parentID: Int64?
    var productsArray: [Post] = []
    var carsDictionary = [String: [String]]()
    var carSectionTitles = [String]()
    var cars = [String]()
    var showIndex = false
    var name = " "
    
    var manufacturer: String!
    var prodTypes: String!
    var models: String!
    var prodName: String!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rangeChar()
        indexFunc()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        self.tableView.reloadData()
    }
    
    func indexFunc() {
        //index
        
        var display: CGFloat
        display = view.bounds.height
        
        tableViewIndex.backgroundColor = UIColor.clear
        if display < 600 {
            tableViewIndex.font = UIFont(name: "Lato", size: 8)!
            tableViewIndex.itemSpacing = 2
        } else if display < 700{
            tableViewIndex.font = UIFont(name: "Lato", size: 10)!
            tableViewIndex.itemSpacing = 4
        } else if display < 800 {
            tableViewIndex.font = UIFont(name: "Lato", size: 11)!
            tableViewIndex.itemSpacing = 4
        } else {
            tableViewIndex.font = UIFont(name: "Lato", size: 12)!
            tableViewIndex.itemSpacing = 4
        }
    }
    
    func indexItems(for tableViewIndex: TableViewIndex) -> [UIView] {
        index()
        return carSectionTitles.map{ title -> UIView in
            return StringItem(text: title)
        }
    }
    
    func tableViewIndex(_ tableViewIndex: TableViewIndex, didSelect item: UIView, at index: Int) -> Bool {
        
        if index < carSectionTitles.count {
            let indexPath = NSIndexPath(row: 0, section: index)
            tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
        }
        return true // return true to produce haptic feedback on capable devices
    }
    
    func index() {
        
        if parentID != nil {
            var arr1 = [CategoryEnt]()
            if prodName == "" || prodName == nil {
                arr1 = appDelegate.childs.filter({$0.id == parentID})
                let arr2 = appDelegate.childs.filter({$0.name == arr1.first?.name})
                for i in arr2 {
                    let arr3 = appDelegate.childs.filter({$0.parent == i.id })
                    for j in arr3 {
                        if arr1.contains(where: {$0.id == j.id}) == false {
                            arr1.append(j)
                        }

                    }
                    
                }
            } else {
                arr1 = appDelegate.childs.filter({$0.name == prodName})
            }
            for i in arr1 {
                if manufacturer == nil || manufacturer == "" {
                        if appDelegate.curentPdf.contains(where: {$0.model_name == i.name}) {
                            let car = appDelegate.curentPdf.filter({$0.model_name == i.name})
                                if cars.contains((car.first?.model_name)!) == false {
                                    cars.append((car.first?.model_name)!)
                                }
                        } else {
                            if appDelegate.curentPdf.contains(where: {$0.model_number == i.name}) {
                                let car = appDelegate.curentPdf.filter({$0.model_number == i.name})
                                if cars.contains((car.first?.model_number)!) == false {
                                    cars.append((car.first?.model_number)!)
                                }
                            }
                        }
                } else {
                    if appDelegate.curentPdf.contains(where: {$0.model_name == i.name}) {
                        let car = appDelegate.curentPdf.filter({$0.model_name == i.name})
                        if manufacturer != nil && manufacturer != "" {
                            if cars.contains((car.first?.model_name)!) == false {
                                cars.append((car.first?.model_name)!)
                            }
                        } else {
                            cars.append((car.first?.model_name)!)
                        }
                    } else {
                        if appDelegate.curentPdf.contains(where: {$0.model_number == i.name}) {
                            
                            let car = appDelegate.curentPdf.filter({$0.model_number == i.name})
                            if cars.contains((car.first?.model_number)!) == false {
                                cars.append((car.first?.model_number)!)
                            }
                        }
                    }
                }
            }
        } else {
            for i in appDelegate.curentPdf {
                cars.append(i.model_name!)
            }
        }
        for car in cars {
            let carKey = String(car.prefix(1))
            if var carValues = carsDictionary[carKey] {
                carValues.append(car)
                carsDictionary[carKey] = carValues
            } else {
                carsDictionary[carKey] = [car]
            }
        }
        carSectionTitles = [String](carsDictionary.keys)
        carSectionTitles = carSectionTitles.sorted(by: { $0 < $1 })
    }
    
    //    nameLbl char range
    fileprivate func rangeChar() {
        let attributedString = nameLbl.attributedText as! NSMutableAttributedString
        attributedString.addAttribute(kCTKernAttributeName as NSAttributedString.Key, value: 3.0, range: NSMakeRange(0, attributedString.length))
        nameLbl.attributedText = attributedString
    }
    
    @IBAction func backBut(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuBut(_ sender: Any) {
        //sideMenu
    }
    
}


extension Product {
    
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        let footerViewSub = UIView()
        footerViewSub.frame =  CGRect(x: 25     , y: 0, width:
            tableView.bounds.size.width - 65 , height: 0.5)
        footerView.backgroundColor = UIColor.white.withAlphaComponent(1)
        //        footerViewSub.backgroundColor = UIColor(red: 241/255, green: 243/255, blue: 246/255, alpha: 1)
        //        footerView.addSubview(footerViewSub)
        return footerView
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerLabel = UILabel()
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        headerLabel =
            UILabel(frame: CGRect(x: 25, y: 0, width:
                tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "Lato-Black", size: 15)
        headerLabel.textColor = UIColor(red: 181/255, green: 193/255, blue: 209/255, alpha: 1)
        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return carSectionTitles[section]
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // 1
        return carSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 2
        
        let carKey = carSectionTitles[section]
        if let carValues = carsDictionary[carKey] {
            return carValues.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 3
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell4", for: indexPath) as! ProductsTVCell
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 241/255, green: 243/255, blue: 246/255, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        
        cell.separatorInset.left = CGFloat(25)
        cell.separatorInset.right = CGFloat(40)
        // Configure the cell...
        let carKey = carSectionTitles[indexPath.section]
        if let carValues = carsDictionary[carKey] {
            cell.prodLbl.text = carValues[indexPath.row]
        }
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        tableView.sectionIndexColor = UIColor(red: 40/255, green: 36/255, blue: 58/255, alpha: 1)
        
        
        //        return carSectionTitles
        return [" "]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var text = " "
        
        let cell = tableView.cellForRow(at: indexPath) as! ProductsTVCell
        
        if cell.prodLbl.text != nil {
            text = cell.prodLbl.text!
        }
        
        performSegue(withIdentifier: "showVitalStatistics", sender: text)
    }
    
    
    //MARK: -Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVitalStatistics" {
            
            let name = sender as! String
            
            let vs = segue.destination as! VitalStatVC
            vs.name = name
        }
        
    }
}

