import UIKit
import Firebase

class VitalStatVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var starBut: UIButton!
    
    @IBOutlet weak var tableView2: UITableView!
    
    
    //fire
    var user: UserModel!
    var ref: DatabaseReference!
    var favor = Array<Favor>()
    
    var manufacturer2: String!
    var prodTypes: String!
    var cell: UITableViewCell!
    var name = " "
    var fieldsDict = [String:String]()
    var keysAZ = [String]()
    var prodArr = [PdfDocumentInfo]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("name \(name)")
        rangeChar()
        tableView1.isScrollEnabled = false
        checkStar()
        prodArr = appDelegate.curentPdf.filter({$0.model_name == name})
        if prodArr.isEmpty == true {
            prodArr = appDelegate.curentPdf.filter({$0.model_number == name})
        }
        addDataToDict()
        var model2 = appDelegate.childs.filter({$0.name == name})
        var prod = appDelegate.childs.filter({$0.id == model2.first?.parent})
        var manuf = appDelegate.parents.filter({$0.id == prod.first?.parent})
        
        //menufacturer lbl
//        manufacturer.text = manuf.first?.name
//
//        //prod lbl
//
//
//
//        prodType.text = prod.first?.name
//
//        //model lbl
//        model.text = name
//
        //fire
        guard let currentUser = Auth.auth().currentUser else { return }
        user = UserModel(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("favor")
    }
    
    var nameVC = "VitalStatVC"
    
    //    nameLbl char range
    fileprivate func rangeChar() {
        let attributedString = nameLbl.attributedText as! NSMutableAttributedString
        attributedString.addAttribute(kCTKernAttributeName as NSAttributedString.Key, value: 3.0, range: NSMakeRange(0, attributedString.length))
        nameLbl.attributedText = attributedString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView1.reloadData()
        checkStar()
        
        
    }
    
    override func viewWillLayoutSubviews() {
        self.tableView1.reloadData()
    }
    
    fileprivate func buttonChang(senderButton: UIButton,senderSwitch: Bool) {
        if senderSwitch == false {
            starBut.setImage(UIImage(named: "star"), for: UIControl.State.normal)
        } else {
            starBut.setImage(UIImage(named: "star_active"), for: UIControl.State.normal)
        }
    }
    
    func checkStar() {
        if appDelegate.favourites.contains(where: {$0 == name}) {
            starBut.setImage(UIImage(named: "star_active"), for: .normal)
        } else {
            starBut.setImage(UIImage(named: "star"), for: .normal)
        }
    }
    
    @IBAction func backBut(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuBut(_ sender: Any) {
        //sideMenu
    }
    
    @IBAction func starBut(_ sender: Any) {
        print(name)
        
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
}

extension VitalStatVC {
    
    //MARK: -table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if tableView == tableView1 {
            count = 2
        }
        if tableView == tableView2 {
            count = keysAZ.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tableView1 {
            let cell1  = tableView.dequeueReusableCell(withIdentifier: "Cell5", for: indexPath) as! VitalTVCell
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor(red: 241/255, green: 243/255, blue: 246/255, alpha: 1.0)
            cell.selectedBackgroundView = backgroundView
            
            if indexPath.row == 0 {
                var arr = appDelegate.curentPdf.filter({$0.model_name == name})
                if arr.isEmpty == true {
                    arr = appDelegate.curentPdf.filter({$0.model_number == name})
                }
                let info = arr.first?.modified
                if info != nil && info != "" {
                    if arr.first?.alerts != nil && arr.first?.alerts != "" && arr.first?.alerts != "false" {
                        let a = UIImage(named: "Alert")!
                        cell1.imgView.image = a
                        
                        let info2 = info?.dropLast(9)
                        
                        cell1.contentLbl.text = String(info2!)
                        cell1.accessoryType = .disclosureIndicator
                        cell1.selectionStyle = .default
                    } else {
                        cell1.contentLbl.text = " "
                        cell1.imgView.image = nil
                        cell1.selectionStyle = .none
                        cell1.seperatorColor.backgroundColor = UIColor.white
                    }
                } else {
                    cell1.contentLbl.text = " "
                    cell1.imgView.image = nil
                    cell1.selectionStyle = .none
                    cell1.seperatorColor.backgroundColor = UIColor.white
                }
            } else {
                if appDelegate.curentPdf.contains(where: {$0.model_name == name}) == true || appDelegate.curentPdf.contains(where: {$0.model_number == name}) == true {
                    var a = appDelegate.curentPdf.filter({$0.model_name == name})
                    if a.isEmpty == true {
                        a = appDelegate.curentPdf.filter({$0.model_number == name})
                    }
                    if a.first?.info != nil && a.first?.info != "false" && a.first?.info != "" {
                        let b = UIImage(named: "Info")
                        cell1.imgView.image = b
                        cell1.contentLbl.text = "MRI Conditional"
                        cell1.accessoryType = .disclosureIndicator
                        cell1.selectionStyle = .default
                    } else {
                        cell1.contentLbl.text = ""
                        cell1.imgView.image = nil
                        cell1.selectionStyle = .none
                        cell1.seperatorColor.backgroundColor = UIColor.white
                    }
                } else {
                    cell1.contentLbl.text = ""
                    cell1.imgView.image = nil
                    cell1.selectionStyle = .none
                    cell1.seperatorColor.backgroundColor = UIColor.white
                }
                
            }
            
            cell = cell1
        }
        if tableView == tableView2 {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "VitalStatInfo", for: indexPath) as! VitalTVCell2
            let key = keysAZ[indexPath.row]
            cell2.nameLbl.text = key
            cell2.contentLbl.text = fieldsDict[key]
           cell = cell2
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.row == 0 {
            //search in current
            if appDelegate.curentPdf.contains(where: {$0.model_name == name}) == true || appDelegate.curentPdf.contains(where: {$0.model_number == name}) == true {
                var a = appDelegate.curentPdf.filter({$0.model_name == name})
                if a.isEmpty == true {
                    a = appDelegate.curentPdf.filter({$0.model_number == name})
                }
                if a.first?.alerts != nil && a.first?.alerts != "" && a.first?.alerts != "false" {
                    performSegue(withIdentifier: "showPDF", sender: indexPath)
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
                    performSegue(withIdentifier: "showPDF", sender: indexPath)
                    cell.selectionStyle = .default
                } else {
                    cell.selectionStyle = .none
                }
            } else {
                cell.selectionStyle = .none
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPDF" {
            
            let indexPath = sender as! IndexPath
            let pDFLoadVC = segue.destination as! PDFviewerVC
            pDFLoadVC.nameVC = nameVC
            if indexPath.row == 0 {
                pDFLoadVC.name = "\(name)Alert"
            } else {
                pDFLoadVC.name = "\(name)Info"
            }
            
        }
    }
    
    func addDataToDict() {
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
    }
    
}
