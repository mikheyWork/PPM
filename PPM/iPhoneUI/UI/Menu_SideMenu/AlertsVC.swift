import UIKit
import MYTableViewIndex

class AlertsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, TableViewIndexDataSource, TableViewIndexDelegate {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var top5But: UIButton!
    @IBOutlet weak var azBut: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewIndex: TableViewIndex!
    
    //MARK: -variables
    var isTop5Taped = true
    var isAzTabep = false
    var nameVC = "VitalStatVC"
    var carsDictionary = [String: [Alert]]()
    var carSectionTitles = [String]()
    var cars = [Alert]()
    var showIndex = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rangeChar()
        top5But.layer.cornerRadius = 14
        azBut.layer.cornerRadius = 14
        buttonChang(senderButton: top5But, senderSwitch: isTop5Taped)
        buttonChang(senderButton: azBut, senderSwitch: isAzTabep)
        indexFunc()
        showindexF()
    }
    
    func showindexF() {
        if isAzTabep {
           tableViewIndex.isHidden = false
        } else {
            tableViewIndex.isHidden = true
        }
        
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
        } else {
        }
        return true // return true to produce haptic feedback on capable devices
    }
    
    func index() {
        
        
        carsDictionary.removeAll()
        carSectionTitles.removeAll()
        cars.removeAll()
        
        for i in appDelegate.curentPdf {
            if i.alerts != nil && i.alerts != "false" && i.alerts != "" {
                var a: Alert!
                if i.model_name != "" && i.model_name != "_" && i.model_name != "false" {
                    a = Alert(name: i.model_name!, date: i.modified!)
                } else {
                    a = Alert(name: i.model_number!, date: i.modified!)
                }
                
                if cars.contains(where: {$0.name == i.model_name}) == false {
                    cars.append(a)
                }
            }
           
        }
        
        if isAzTabep {
            cars = cars.sorted(by: {$0.name > $1.name})
        } else if isTop5Taped {
            cars = cars.sorted(by: {$0.date > $1.date})
        } else {

        }
       
        
        for car in cars {
            let carKey = String(car.name.prefix(1))
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
    
    fileprivate func buttonChang(senderButton: UIButton,senderSwitch: Bool) {
        if senderSwitch == false {
            senderButton.layer.borderWidth = 1
            senderButton.layer.borderColor = (UIColor(red: 181/255, green: 193/255, blue: 208/255, alpha: 1)).cgColor
            senderButton.backgroundColor = UIColor.white
            senderButton.setTitleColor(UIColor(red: 35/255, green: 52/255, blue: 70/255, alpha: 1), for: .normal)
        } else {
            
            
            senderButton.layer.borderWidth = 0
            senderButton.backgroundColor = UIColor(red: 35/255, green: 52/255, blue: 70/255, alpha: 1)
            senderButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        self.tableView.reloadData()
    }
    
    //nameLbl char range
    fileprivate func rangeChar() {
        let attributedString = nameLbl.attributedText as! NSMutableAttributedString
        attributedString.addAttribute(kCTKernAttributeName as NSAttributedString.Key, value: 3.0, range: NSMakeRange(0, attributedString.length))
        nameLbl.attributedText = attributedString
    }
    
    @IBAction func top5Tap(_ sender: Any) {
        if isTop5Taped == false {
            isTop5Taped = true
            isAzTabep = false
        } else {
            isTop5Taped = false
            isAzTabep = true
        }
        buttonChang(senderButton: top5But, senderSwitch: isTop5Taped)
        buttonChang(senderButton: azBut, senderSwitch: isAzTabep)
        if showIndex == false {
            showIndex = true
        } else {
            showIndex = false
        }
        index()
        self.tableView.reloadData()
        showindexF()
    }
    
    @IBAction func azTap(_ sender: Any) {
        if isAzTabep == false {
            isAzTabep = true
            isTop5Taped = false
        } else {
            isAzTabep = false
            isTop5Taped = true
        }
        buttonChang(senderButton: azBut, senderSwitch: isAzTabep)
        buttonChang(senderButton: top5But, senderSwitch: isTop5Taped)
        if showIndex == false {
            showIndex = true
        } else {
            showIndex = false
        }
        
        index()
        self.tableView.reloadData()
        showindexF()
    }
    
    @IBAction func backBut(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuBut(_ sender: Any) {
        //sideMenu
    }
}


extension AlertsVC {
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
            
            footerView.backgroundColor = UIColor.white.withAlphaComponent(1)
        return footerView
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerLabel = UILabel()
        let headerView = UIView()
        if isAzTabep {
            
            headerView.backgroundColor = UIColor.white
            headerLabel =
                UILabel(frame: CGRect(x: 25, y: 0, width:
                    tableView.bounds.size.width, height: tableView.bounds.size.height))
            headerLabel.font = UIFont(name: "Lato-Black", size: 15)
            headerLabel.textColor = UIColor(red: 181/255, green: 193/255, blue: 209/255, alpha: 1)
            headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
            headerLabel.sizeToFit()
            headerView.addSubview(headerLabel)
        }
        
        return headerView
    }
    
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var stringName: String!
            stringName = carSectionTitles[section]
        return stringName
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var count: Int!
        if isAzTabep == true {
           count = carSectionTitles.count
        } else {
            return 1
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isAzTabep == true {
            let carKey = carSectionTitles[section]
            if let carValues = carsDictionary[carKey] {
                return carValues.count
            }
            
        } else {
            return cars.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 3
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell6", for: indexPath) as! AlertsTVCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 241/255, green: 243/255, blue: 246/255, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        
        
        if isAzTabep == true {
            let carKey = carSectionTitles[indexPath.section]
            if let carValues = carsDictionary[carKey] {
                cell.nameLbl.text = carValues[indexPath.row].name
            }
            let text = cell.nameLbl.text
            let arr = cars.filter({$0.name == text})
            let alert = arr.first?.date
            
            let date = alert?.dropLast(9)
            let time = alert?.dropFirst(11)
            
            cell.dateLbl.text = "\(date!)   \(time!)"
        } else {
            var a = cars[indexPath.row].name
//            if a == nil || a?.isEmpty == true {
//                a = cars[indexPath.row].name
//            }
            cell.nameLbl.text = a
            
            let alert = cars[indexPath.row].date
            
            let date = alert?.dropLast(9)
            let time = alert?.dropFirst(11)
            
            cell.dateLbl.text = "\(date!)   \(time!)"
        }
        
        
//        if self.isAzTabep {
//            cell.separatorInset.left = CGFloat(25)
//            cell.separatorInset.right = CGFloat(40)
            // Configure the cell...
//            let carKey = carSectionTitles[indexPath.section]
//            if let carValues = carsDictionary[carKey] {
//                cell.nameLbl.text = carValues[indexPath.row]
//            }
//        } else {
//            cell.separatorInset.left = CGFloat(25)
//            cell.separatorInset.right = CGFloat(25)
//            cell.nameLbl.text = cars[indexPath.row].name
//        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {

        if isAzTabep {
            tableView.sectionIndexColor = UIColor(red: 40/255, green: 36/255, blue: 58/255, alpha: 1)
            return [" "]
        }
        return []
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var text = " "
        
        let cell = tableView.cellForRow(at: indexPath) as! AlertsTVCell
        
        if cell.nameLbl.text != nil {
            text = cell.nameLbl.text!
        }
            performSegue(withIdentifier: "showAlertsPdf", sender: text)
    }
    
    //MARK: -Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAlertsPdf" {
            let name = sender as! String
            
            let vs = segue.destination as! VitalStatVC
            vs.name = name
        }
        if segue.identifier == "showAlertsRef" {
            let name = sender as! String
            
            let vs = segue.destination as! PDFviewerVC
            vs.name = name
        }
    }
}


class Alert {
    var name: String!
    var date: String!
    
    init(name: String, date: String) {
        self.date = date
        self.name = name
    }
}
