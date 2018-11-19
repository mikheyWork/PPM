import Foundation
class PdfDocumentInfo: NSObject, NSCoding {
    
    var alerts: String?
    var model_number: String?
    var info: String?
    var model_name: String?
    var manufacturer: String?
    var modified: String?
    var nbg_code: String?
    var polarity: String?
    var sensor_type: String?
    var dimensions_size: String?
    var dimensions_weight: String?
    var connectores_pace_sense: String?
    var mri_conditional: String?
    var wireless_telemetry: String?
    var remote_monitoring: String?
    var non_magnet_rate: String?
    var magnet_rate_bol: String?
    var magnet_rate_eri_eol: String?
    var patient_alert_feature: String?
    var detach_tools: String?
    var x_rey_id: String?
    var nbd_code: String?
    var max_energy: String?
    var hv_waveform: String?
    var connectores_hight_voltage: String?
    var eri_notes: String?
    var bol_characteristics: String?
    var eri_eol_characteristics: String?
    var lead_polarity: String?
    var fixation: String?
    var insulation_material: String?
    var max_lead_diameter: String?
    var placement: String?
    var number_of_hv_coils: String?
    
    
    
    init(alerts: String?,
         model_number: String?,
         info: String?,
         model_name: String?,
         manufacturer: String?,
         modified: String?,
         nbg_code: String?,
         polarity: String?,
         sensor_type: String?,
         dimensions_size: String?,
         dimensions_weight: String?,
         connectores_pace_sense: String?,
         mri_conditional: String?,
         wireless_telemetry: String?,
         remote_monitoring: String?,
         non_magnet_rate: String?,
         magnet_rate_bol: String?,
         magnet_rate_eri_eol: String?,
         patient_alert_feature: String?,
         detach_tools: String?,
         x_rey_id: String?,
         nbd_code: String?,
         max_energy: String?,
         hv_waveform: String?,
         connectores_hight_voltage: String?,
         eri_notes: String?,
         bol_characteristics: String?,
         eri_eol_characteristics: String?,
         lead_polarity: String?,
         fixation: String?,
         insulation_material: String?,
         max_lead_diameter: String?,
         placement: String?,
         number_of_hv_coils: String?) {
        self.alerts = alerts
        self.model_number = model_number
        self.info = info
        self.model_name = model_name
        self.manufacturer = manufacturer
        self.modified = modified
        self.nbg_code = nbg_code
        self.polarity = polarity
        self.sensor_type = sensor_type
        self.dimensions_size = dimensions_size
        self.dimensions_weight = dimensions_weight
        self.connectores_pace_sense = connectores_pace_sense
        self.mri_conditional = mri_conditional
        self.wireless_telemetry = wireless_telemetry
        self.wireless_telemetry = wireless_telemetry
        self.remote_monitoring = remote_monitoring
        self.non_magnet_rate = non_magnet_rate
        self.magnet_rate_bol = magnet_rate_bol
        self.magnet_rate_eri_eol = magnet_rate_eri_eol
        self.patient_alert_feature = patient_alert_feature
        self.detach_tools = detach_tools
        self.x_rey_id = x_rey_id
        self.nbd_code = nbd_code
        self.max_energy = max_energy
        self.hv_waveform = hv_waveform
        self.connectores_hight_voltage = connectores_hight_voltage
        self.eri_notes = eri_notes
        self.bol_characteristics = bol_characteristics
        self.eri_eol_characteristics = eri_eol_characteristics
        self.lead_polarity = lead_polarity
        self.fixation = fixation
        self.insulation_material = insulation_material
        self.max_lead_diameter = max_lead_diameter
        self.placement = placement
        self.number_of_hv_coils = number_of_hv_coils
        
        
    }
    
    //decoding
    required convenience init?(coder aDecoder: NSCoder) {
        let alerts = aDecoder.decodeObject(forKey: "alerts") as! String
        let model_number = aDecoder.decodeObject(forKey: "model_number") as! String
        let info = aDecoder.decodeObject(forKey: "info") as! String
        let model_name = aDecoder.decodeObject(forKey: "model_name") as! String
        let manufacturer = aDecoder.decodeObject(forKey: "manufacturer") as! String
        let modified = aDecoder.decodeObject(forKey: "modified") as! String
        let nbg_code = aDecoder.decodeObject(forKey: "nbg_code") as! String
        let polarity = aDecoder.decodeObject(forKey: "polarity") as! String
        let sensor_type = aDecoder.decodeObject(forKey: "sensor_type") as! String
         let dimensions_size = aDecoder.decodeObject(forKey: "dimensions_size") as! String
        let dimensions_weight = aDecoder.decodeObject(forKey: "dimensions_weight") as! String
         let connectores_pace_sense = aDecoder.decodeObject(forKey: "connectores_pace_sense") as! String
        let mri_conditional = aDecoder.decodeObject(forKey: "mri_conditional") as! String
        let wireless_telemetry = aDecoder.decodeObject(forKey: "wireless_telemetry") as! String
        let remote_monitoring = aDecoder.decodeObject(forKey: "remote_monitoring") as! String
        let non_magnet_rate = aDecoder.decodeObject(forKey: "non_magnet_rate") as! String
        let magnet_rate_bol = aDecoder.decodeObject(forKey: "magnet_rate_bol") as! String
         let magnet_rate_eri_eol = aDecoder.decodeObject(forKey: "magnet_rate_eri_eol") as! String
         let patient_alert_feature = aDecoder.decodeObject(forKey: "patient_alert_feature") as! String
         let detach_tools = aDecoder.decodeObject(forKey: "detach_tools") as! String
         let x_rey_id = aDecoder.decodeObject(forKey: "x_rey_id") as! String
        let nbd_code = aDecoder.decodeObject(forKey: "nbd_code") as! String
        let max_energy = aDecoder.decodeObject(forKey: "max_energy") as! String
        let hv_waveform = aDecoder.decodeObject(forKey: "hv_waveform") as! String
        let connectores_hight_voltage = aDecoder.decodeObject(forKey: "connectores_hight_voltage") as! String
        let eri_notes = aDecoder.decodeObject(forKey: "eri_notes") as! String
        let bol_characteristics = aDecoder.decodeObject(forKey: "bol_characteristics") as! String
        let eri_eol_characteristics = aDecoder.decodeObject(forKey: "eri_eol_characteristics") as! String
        let lead_polarity = aDecoder.decodeObject(forKey: "lead_polarity") as! String
        let fixation = aDecoder.decodeObject(forKey: "fixation") as! String
        let insulation_material = aDecoder.decodeObject(forKey: "insulation_material") as! String
        let max_lead_diameter = aDecoder.decodeObject(forKey: "max_lead_diameter") as! String
        let placement = aDecoder.decodeObject(forKey: "placement") as! String
        let number_of_hv_coils = aDecoder.decodeObject(forKey: "number_of_hv_coils") as! String
        self.init(alerts: alerts,
                  model_number: model_number,
                  info: info,
                  model_name: model_name,
                  manufacturer: manufacturer,
                  modified: modified,
                  nbg_code: nbg_code,
                  polarity: polarity,
                  sensor_type: sensor_type,
                  dimensions_size: dimensions_size,
                  dimensions_weight: dimensions_weight,
                  connectores_pace_sense: connectores_pace_sense,
                  mri_conditional: mri_conditional,
                  wireless_telemetry: wireless_telemetry,
                  remote_monitoring: remote_monitoring,
                  non_magnet_rate: non_magnet_rate,
                  magnet_rate_bol: magnet_rate_bol,
                  magnet_rate_eri_eol: magnet_rate_eri_eol,
                  patient_alert_feature: patient_alert_feature,
                  detach_tools: detach_tools,
                  x_rey_id: x_rey_id,
                  nbd_code: nbd_code,
                  max_energy: max_energy,
                  hv_waveform: hv_waveform,
                  connectores_hight_voltage: connectores_hight_voltage,
                  eri_notes: eri_notes,
                  bol_characteristics: bol_characteristics,
                  eri_eol_characteristics: eri_eol_characteristics,
                  lead_polarity: lead_polarity,
                  fixation: fixation,
                  insulation_material: insulation_material,
                  max_lead_diameter: max_lead_diameter,
                  placement: placement,
                  number_of_hv_coils: number_of_hv_coils)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(alerts, forKey: "alerts")
        aCoder.encode(model_number, forKey: "model_number")
        aCoder.encode(info, forKey: "info")
        aCoder.encode(model_name, forKey: "model_name")
        aCoder.encode(manufacturer, forKey: "manufacturer")
        aCoder.encode(modified, forKey: "modified")
        aCoder.encode(nbg_code, forKey: "nbg_code")
        aCoder.encode(polarity, forKey: "polarity")
        aCoder.encode(sensor_type, forKey: "sensor_type")
        aCoder.encode(dimensions_size, forKey: "dimensions_size")
        aCoder.encode(dimensions_weight, forKey: "dimensions_weight")
        aCoder.encode(connectores_pace_sense, forKey: "connectores_pace_sense")
        aCoder.encode(mri_conditional, forKey: "mri_conditional")
        aCoder.encode(wireless_telemetry, forKey: "wireless_telemetry")
        aCoder.encode(remote_monitoring, forKey: "remote_monitoring")
        aCoder.encode(non_magnet_rate, forKey: "non_magnet_rate")
        aCoder.encode(magnet_rate_bol, forKey: "magnet_rate_bol")
        aCoder.encode(magnet_rate_eri_eol, forKey: "magnet_rate_eri_eol")
        aCoder.encode(patient_alert_feature, forKey: "patient_alert_feature")
        aCoder.encode(detach_tools, forKey: "detach_tools")
        aCoder.encode(x_rey_id, forKey: "x_rey_id")
        aCoder.encode(nbd_code, forKey: "nbd_code")
        aCoder.encode(max_energy, forKey: "max_energy")
        aCoder.encode(hv_waveform, forKey: "hv_waveform")
        aCoder.encode(connectores_hight_voltage, forKey: "connectores_hight_voltage")
        aCoder.encode(eri_notes, forKey: "eri_notes")
        aCoder.encode(bol_characteristics, forKey: "bol_characteristics")
        aCoder.encode(eri_eol_characteristics, forKey: "eri_eol_characteristics")
        aCoder.encode(lead_polarity, forKey: "lead_polarity")
        aCoder.encode(fixation, forKey: "fixation")
        aCoder.encode(insulation_material, forKey: "insulation_material")
        aCoder.encode(max_lead_diameter, forKey: "max_lead_diameter")
        aCoder.encode(placement, forKey: "placement")
        aCoder.encode(number_of_hv_coils, forKey: "number_of_hv_coils")
    }
}
