import UIKit
import Firebase

class VitalFullScrennVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var starBut: UIButton!
    @IBOutlet weak var tableView3: UITableView!
    
    @IBOutlet weak var tableView4: UITableView!
    
    
    
    @IBOutlet weak var tableView6: UITableView!

    @IBOutlet weak var webView: UIWebView!
    
    var parentID: Int64?
    var cell: UITableViewCell!
    var starIsTaped = true
    var name = " "
    var carsDictionary = [String: [String]]()
    var carSectionTitles = [String]()
    var cars = [String]()
    
    //fire
    var user: UserModel!
    var ref: DatabaseReference!
    var favor = Array<Favor>()
    
    var a = [CategoryEnt]()
    var b = [ReferEnt]()
    
    var prodArr = [PdfDocumentInfo]()
    var fieldsDict = [String:String]()
    var keysAZ = [String]()
    var keysAZAll = [String]()
    var keysAZ1 = [String]()
    var keysAZ2 = [String]()
    var keysCount1 = 0
    var keysCount2 = 0
    var trueName = ""
    var orientation = false
    var namePdf = ""
    var readed = false
    var name2 = ""
    var nameRead = ""
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        index()
        
        namePdf = PDFDownloader.shared.addPercent(fromString: name)
        if readed == true {
            webView.isHidden = false
            read(nameFile: nameRead)
        } else {
            webView.isHidden = true
        }
        addDataToDict()
        trueName = name
        
        rangeChar(label: nameLbl)
        checkStar()
        
        //fire
        guard let currentUser = Auth.auth().currentUser else { return }
        user = UserModel(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("favor")
        
        //find element
        a = appDelegate.childs.filter({$0.name == name })
        b = [ReferEnt]()
        if a.isEmpty == true {
            b = appDelegate.referencesChild.filter({$0.name == name })
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        orient()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        orient()
    }
    
    func orient() {
        let orient = UIDevice.current.orientation
        if orient.isLandscape {
            orientation = true
        } else {
            orientation = false
        }
        tableView3.reloadData()
        tableView4.reloadData()
    }
    
    func index() {
        
        if parentID != nil {
            let resault = appDelegate.childs.filter{$0.id == parentID}
            for i in resault {
                if cars.contains(i.name!) == false {
                    cars.append(i.name!)
                }
            }
        } else {
            for i in appDelegate.childs {
                if cars.contains(i.name!) == false {
                    cars.append(i.name!)
                }
            }
        }
        
        // 1
        for car in cars {
            let carKey = String(car.prefix(1))
            if var carValues = carsDictionary[carKey] {
                carValues.append(car)
                carsDictionary[carKey] = carValues
            } else {
                carsDictionary[carKey] = [car]
            }
        }
        
        // 2
        carSectionTitles = [String](carsDictionary.keys)
        carSectionTitles = carSectionTitles.sorted(by: { $0 < $1 })
        
    }
    
    
    //    nameLbl char range
    fileprivate func rangeChar(label: UILabel) {
        let attributedString = label.attributedText as! NSMutableAttributedString
        attributedString.addAttribute(kCTKernAttributeName as NSAttributedString.Key, value: 3.0, range: NSMakeRange(0, attributedString.length))
        label.attributedText = attributedString
    }
    
    fileprivate func buttonChang(senderButton: UIButton,senderSwitch: Bool) {
        if senderSwitch == false {
            starBut.setImage(UIImage(named: "star"), for: UIControl.State.normal)
        } else {
            starBut.setImage(UIImage(named: "star_active"), for: UIControl.State.normal)
        }
    }
    
    
    
    @IBAction func backBut(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func backBut2(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func menuBut(_ sender: Any) {
        //sideMenu
    }
    
    @IBAction func starBut(_ sender: Any) {
        if self.appDelegate.curentPdf.contains(where: {$0.model_name == name}) == true || self.appDelegate.curentPdfRef.contains(where: {$0.title == name}) == true || self.appDelegate.curentPdf.contains(where: {$0.model_number == name}) == true {
            if appDelegate.favourites.contains(where: { $0 == name }) {
                appDelegate.favourites = appDelegate.favourites.filter({$0 != name})
                if appDelegate.favourites.isEmpty == true {
                    ref.removeValue()
                } else {
                    var arrayFav = [String]()
                    for fav in appDelegate.favourites {
                        arrayFav.append(fav)
                    }
                    UserDefaults.standard.set(arrayFav, forKey: "favorArr")
                    let favor = Favor(favArray: arrayFav, userId: user.uid)
                    let favorRef = self.ref.child("title")
                    favorRef.setValue(["favor": favor.favArray ,"userId": favor.userId])
                }
                
            } else {
                
                let element = appDelegate.childs.filter({$0.name == name})
                var nameElement = element.first?.name
                if nameElement == "" || nameElement == nil  {
                    let element2 = appDelegate.referencesChild.filter(({$0.name == name}))
                    nameElement = element2.first?.name
                }
                appDelegate.favourites.append(nameElement!)
                var arrayFav = [String]()
                if appDelegate.favourites.isEmpty == false {
                    for fav in appDelegate.favourites {
                        arrayFav.append(fav)
                    }
                }
                UserDefaults.standard.set(arrayFav, forKey: "favorArr")
                let favor = Favor(favArray: arrayFav, userId: user.uid)
                let favorRef = self.ref.child("title")
                favorRef.setValue(["favor": favor.favArray ,"userId": favor.userId])
            }
        }
        checkStar()
    }
    
    
    
    func checkStar() {
        if appDelegate.favourites.contains(where: {$0 == name2}) {
            starBut.setImage(UIImage(named: "star_active"), for: .normal)
        } else {
            starBut.setImage(UIImage(named: "star"), for: .normal)
        }
    }
    
    func read(nameFile: String) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("\(nameFile).pdf")
            //reading
            let request = URLRequest(url: fileURL)
            self.webView.loadRequest(request)
        }
    }
    
}


extension VitalFullScrennVC {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView3 {
                 return keysAZ1.count
        }
        
        if tableView == self.tableView4 {
                return keysAZ2.count + 2
        }
        
        if tableView == self.tableView6 {
            return 2
        }
        
        return 2
    }
    

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableView == self.tableView3 {
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "CellTable3", for: indexPath) as! VitalTVCell
            cell3.contentLbl.text = ""
            cell3.nameLbl.text = ""
                if indexPath.row < keysAZ1.count {
                    let key = keysAZ1[indexPath.row]
                    cell3.nameLbl.text = key
                    cell3.contentLbl.text = fieldsDict[key]
                }
            cell = cell3
        }
        
        if tableView == tableView4 {
            let cell4 = tableView.dequeueReusableCell(withIdentifier: "CellTable4", for: indexPath) as! VitalTVCell
            cell4.contentLbl.text = ""
            cell4.nameLbl.text = ""
                if indexPath.row < keysAZ2.count {
                    let key = keysAZ2[indexPath.row]
                    cell4.nameLbl.text = key
                    cell4.contentLbl.text = fieldsDict[key]
                }
            cell = cell4
        }
        
        if tableView == tableView6 {
            let cell6 = tableView.dequeueReusableCell(withIdentifier: "CellTable6", for: indexPath) as! VitalStatSeg
            if indexPath.row == 0 {
                //                name = PDFDownloader.shared.addPercent(fromString: name)
                var arr = [PdfDocumentInfo]()
                if arr.isEmpty == false {
                    arr.removeAll()
                }
                arr = appDelegate.curentPdf.filter({$0.model_name == name})
                if arr.isEmpty == true {
                    arr = appDelegate.curentPdf.filter({$0.model_number == name})
                }
                let info = arr.first?.modified
                if info != nil && info != "" {
                    if arr.first?.alerts != nil && arr.first?.alerts != "" && arr.first?.alerts != "false" {
                        let a = UIImage(named: "Alert")!
                        cell6.imgView.image = a
                        
                        let info2 = info?.dropLast(9)
                        
                        cell6.nameLbl.text = String(info2!)
                        cell6.accessoryType = .disclosureIndicator
                        cell6.selectionStyle = .default
                        cell6.hideView.isHidden = true
                    } else {
                        cell6.nameLbl.text = " "
                        cell6.imgView.image = nil
                        cell6.selectionStyle = .none
                        cell6.hideView.isHidden = false
                        cell6.accessoryType = .none
                    }
                } else {
                    cell6.nameLbl.text = " "
                    cell6.imgView.image = nil
                    cell6.selectionStyle = .none
                    cell6.hideView.isHidden = false
                    cell6.accessoryType = .none
                }
            } else {
                if appDelegate.curentPdf.contains(where: {$0.model_name == name}) == true || appDelegate.curentPdf.contains(where: {$0.model_number == name}) == true  {
                    var a = appDelegate.curentPdf.filter({$0.model_name == name})
                    if a.isEmpty == true {
                        a = appDelegate.curentPdf.filter({$0.model_number == name})
                    }
                    if a.first?.info != nil && a.first?.info != "false" && a.first?.info != "" {
                        
                        //
                        cell6.imgView.image = UIImage(named: "Info")
                        cell6.nameLbl.text = "MRI Conditional"
                        cell6.accessoryType = .disclosureIndicator
                        cell6.selectionStyle = .default
                        cell6.hideView.isHidden = true
                        //                        cell5.separatorColor.isHidden = false
                    } else {
                        cell6.nameLbl.text = ""
                        cell6.imgView.image = nil
                        cell6.selectionStyle = .none
                        cell6.hideView.isHidden = false
                        cell6.accessoryType = .none
                    }
                } else {
                    cell6.nameLbl.text = ""
                    cell6.imgView.image = nil
                    cell6.selectionStyle = .none
                    cell6.hideView.isHidden = false
                    cell6.accessoryType = .none
                }
            }
            cell = cell6
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableView6 {
            
            if indexPath.row == 0 {
                //search in current
                if appDelegate.curentPdf.contains(where: {$0.model_name == name}) == true || appDelegate.curentPdf.contains(where: {$0.model_number == name}) == true {
                    var a = appDelegate.curentPdf.filter({$0.model_name == name})
                    if a.isEmpty == true {
                        a = appDelegate.curentPdf.filter({$0.model_number == name})
                    }
                    if a.first?.alerts != nil && a.first?.alerts != "" && a.first?.alerts != "false" {
                        //open pdf
                        webView.isHidden = false
                        read(nameFile: "\(namePdf)Alert")
                        
                        cell.selectionStyle = .default
                    } else {
                        cell.selectionStyle = .none
                    }
                } else {
                    cell.selectionStyle = .none
                }
            } else {
                if appDelegate.curentPdf.contains(where: {$0.model_name == name}) == true || appDelegate.curentPdf.contains(where: {$0.model_number == name}) == true {
                    var a = appDelegate.curentPdf.filter({$0.model_name == name})
                    if a.isEmpty == true {
                        a = appDelegate.curentPdf.filter({$0.model_number == name})
                    }
                    if a.first?.info != nil && a.first?.info != "" && a.first?.info != "false" {
                        //open pdf
                        webView.isHidden = false
                        read(nameFile: "\(namePdf)Info")
                        cell.selectionStyle = .default
                    } else {
                        cell.selectionStyle = .none
                    }
                } else {
                    cell.selectionStyle = .none
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    func addDataToDict() {
        
        if prodArr.isEmpty == false {
            prodArr.removeAll()
        }
        if fieldsDict.isEmpty == false {
            fieldsDict.removeAll()
        }
        if keysAZ.isEmpty == false {
            keysAZ.removeAll()
        }
        if keysAZAll.isEmpty == false {
            keysAZAll.removeAll()
        }
        if keysAZ1.isEmpty == false {
            keysAZ1.removeAll()
        }
        if keysAZ2.isEmpty == false {
            keysAZ2.removeAll()
        }
        
        prodArr = appDelegate.curentPdf.filter({$0.model_name == name})
        prodArr = appDelegate.curentPdf.filter({$0.model_name == name})
        if prodArr.isEmpty == true {
            prodArr = appDelegate.curentPdf.filter({$0.model_number == name})
        }
        
        
        //start
        if prodArr.first?.manufacturer != "" && prodArr.first?.manufacturer != "_" {
            fieldsDict["Manufacturer"] = prodArr.first?.manufacturer
            keysAZ.append("Manufacturer")
        }
        if prodArr.first?.model_number != "" && prodArr.first?.model_number != "_" {
            fieldsDict["Model number"] = prodArr.first?.model_number
            keysAZ.append("Model number")
        }
        if prodArr.first?.model_name != "" && prodArr.first?.model_name != "_" {
            fieldsDict["Model name"] = prodArr.first?.model_name
            keysAZ.append("Model name")
        }
        if prodArr.first?.nbg_code != "" && prodArr.first?.nbg_code != "_" {
            fieldsDict["NBG Code"] = prodArr.first?.nbg_code
            keysAZ.append("NBG Code")
        }
        if prodArr.first?.nbd_code != "" && prodArr.first?.nbd_code != "_" {
            fieldsDict["NBD Code"] = prodArr.first?.nbd_code
            keysAZ.append("NBD Code")
        }
        if prodArr.first?.sensor_type != "" && prodArr.first?.sensor_type != "_" {
            fieldsDict["Sensor type"] = prodArr.first?.sensor_type
            keysAZ.append("Sensor type")
        }
        if prodArr.first?.number_of_hv_coils != "" && prodArr.first?.number_of_hv_coils != "_" {
            fieldsDict["Number of HW coils"] = prodArr.first?.number_of_hv_coils
            keysAZ.append("Number of HW coils")
        }
        if prodArr.first?.polarity != "" && prodArr.first?.polarity != "_" {
            fieldsDict["Polarity"] = prodArr.first?.polarity
            keysAZ.append("Polarity")
        }
        if prodArr.first?.max_energy != "" && prodArr.first?.max_energy != "_" {
            fieldsDict["Max energy(Joules)"] = prodArr.first?.max_energy
            keysAZ.append("Max energy(Joules)")
        }
        if prodArr.first?.lead_polarity != "" && prodArr.first?.lead_polarity != "_" {
            fieldsDict["Lead Polarity"] = prodArr.first?.lead_polarity
            keysAZ.append("Lead Polarity")
        }
        if prodArr.first?.fixation != "" && prodArr.first?.fixation != "_" {
            fieldsDict["Fixation(#Terns to Deploy)"] = prodArr.first?.fixation
            keysAZ.append("Fixation(#Terns to Deploy)")
        }
        if prodArr.first?.insulation_material != "" && prodArr.first?.insulation_material != "_" {
            fieldsDict["Insulation Material"] = prodArr.first?.insulation_material
            keysAZ.append("Insulation Material")
        }
        if prodArr.first?.dimensions_size != "" && prodArr.first?.dimensions_size != "_" {
            fieldsDict["Dimensions: Size(H x W x D in mm)"] = prodArr.first?.dimensions_size
            keysAZ.append("Dimensions: Size(H x W x D in mm)")
        }
        if prodArr.first?.max_lead_diameter != "" && prodArr.first?.max_lead_diameter != "_" {
            fieldsDict["Max Lead Diameter(Fr)/ Min Introducer Siz(Fr)"] = prodArr.first?.max_lead_diameter
            keysAZ.append("Max Lead Diameter(Fr)/ Min Introducer Siz(Fr)")
        }
        if prodArr.first?.dimensions_weight != "" && prodArr.first?.dimensions_weight != "_" {
            fieldsDict["Dimensions: Weight(g)/Voltage(cc)"] = prodArr.first?.dimensions_weight
            keysAZ.append("Dimensions: Weight(g)/Voltage(cc)")
        }
        if prodArr.first?.placement != "" && prodArr.first?.placement != "_" {
            fieldsDict["Placement"] = prodArr.first?.placement
            keysAZ.append("Placement")
        }
        if prodArr.first?.connectores_pace_sense != "" && prodArr.first?.connectores_pace_sense != "_" {
            fieldsDict["Connectores Pace/Sense"] = prodArr.first?.connectores_pace_sense
            keysAZ.append("Connectores Pace/Sense")
        }
        if prodArr.first?.connectores_hight_voltage != "" && prodArr.first?.connectores_hight_voltage != "_" {
            fieldsDict["Connectores Hight Voltage"] = prodArr.first?.connectores_hight_voltage
            keysAZ.append("Connectores Hight Voltage")
        }
        if prodArr.first?.mri_conditional != "" && prodArr.first?.mri_conditional != "_" {
            fieldsDict["MRI Conditional"] = prodArr.first?.mri_conditional
            keysAZ.append("MRI Conditional")
        }
        if prodArr.first?.bol_characteristics != "" && prodArr.first?.bol_characteristics != "_" {
            fieldsDict["BOL Characteristics"] = prodArr.first?.bol_characteristics
            keysAZ.append("BOL Characteristics")
        }
        if prodArr.first?.non_magnet_rate != "" && prodArr.first?.non_magnet_rate != "_" {
            fieldsDict["Non Magnet Rate: BOL/(ERI/EOL)"] = prodArr.first?.non_magnet_rate
            keysAZ.append("Non Magnet Rate: BOL/(ERI/EOL)")
        }
        if prodArr.first?.wireless_telemetry != "" && prodArr.first?.wireless_telemetry != "_" {
            fieldsDict["Wireless telemetry"] = prodArr.first?.wireless_telemetry
            keysAZ.append("Wireless telemetry")
        }
        if prodArr.first?.eri_eol_characteristics != "" && prodArr.first?.eri_eol_characteristics != "_" {
            fieldsDict["ERI/EOL Characteristics"] = prodArr.first?.eri_eol_characteristics
            keysAZ.append("ERI/EOL Characteristics")
        }
        if prodArr.first?.magnet_rate_bol != "" && prodArr.first?.magnet_rate_bol != "_" {
            fieldsDict["Magnet Rate:BOL"] = prodArr.first?.magnet_rate_bol
            keysAZ.append("Magnet Rate:BOL")
        }
        if prodArr.first?.remote_monitoring != "" && prodArr.first?.remote_monitoring != "_" {
            fieldsDict["Remote Monitoring"] = prodArr.first?.remote_monitoring
            keysAZ.append("Remote Monitoring")
        }
        if prodArr.first?.patient_alert_feature != "" && prodArr.first?.patient_alert_feature != "_" {
            fieldsDict["Patient Alert Feature"] = prodArr.first?.patient_alert_feature
            keysAZ.append("Patient Alert Feature")
        }
        if prodArr.first?.magnet_rate_eri_eol != "" && prodArr.first?.magnet_rate_eri_eol != "_" {
            fieldsDict["Magnet Rate:ERI/EOL"] = prodArr.first?.magnet_rate_eri_eol
            keysAZ.append("Magnet Rate:ERI/EOL")
        }
        if prodArr.first?.eri_notes != "" && prodArr.first?.eri_notes != "_" {
            fieldsDict["ERI Notes"] = prodArr.first?.eri_notes
            keysAZ.append("ERI Notes")
        }
        if prodArr.first?.detach_tools != "" && prodArr.first?.detach_tools != "_" {
            fieldsDict["Detach Tool"] = prodArr.first?.detach_tools
            keysAZ.append("Detach Tool")
        }
        if prodArr.first?.x_rey_id != "" && prodArr.first?.x_rey_id != "_" {
            fieldsDict["X-ray ID"] = prodArr.first?.x_rey_id
            keysAZ.append("X-ray ID")
        }
        keysAZAll = keysAZ
        if keysAZ.count % 2 == 0 {
            // +1
            keysCount1 = keysAZ.count / 2
            keysCount2 = keysCount1
            
            for _ in 0..<keysCount1 {
                keysAZ1.append(keysAZ.first!)
                keysAZ.removeFirst()
                
            }
            for _ in 0..<keysCount2 {
                keysAZ2.append(keysAZ.first!)
                keysAZ.removeFirst()
            }
            
        } else {
            keysCount1 = (keysAZ.count / 2) + 1
            keysCount2 = keysAZ.count / 2
            
            for _ in 0..<keysCount1 {
                keysAZ1.append(keysAZ.first!)
                keysAZ.removeFirst()
                
            }
            for _ in 0..<keysCount2 {
                keysAZ2.append(keysAZ.first!)
                keysAZ.removeFirst()
            }
        }
    }
    
}

