//
//  ShopListTableViewController.swift
//  DrinksOrder
//
//  Created by doriswlc on 2022/10/27.
//

import UIKit
import MapKit

class ShopListTableViewController: UITableViewController {
    var shops = [ShopField]()
    var shopDics = [String: [ShopField]]()
    var counties = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchShops()
    }

    func fetchShops() {
        if let url = URL(string: "https://api.airtable.com/v0/appWKQiePYTFRgmRM/ShopList") {
            var request = URLRequest(url: url)
            request.setValue("Bearer keySfV0P5ClR74OTq", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, response , error in
                if let data {
                    do {
                        let decoder = JSONDecoder()
                        let shopList = try decoder.decode(ShopList.self, from: data)
                        for i in shopList.records.indices {
                            let shop = ShopField(shopName: shopList.records[i].fields.shopName, county: shopList.records[i].fields.county, phone: shopList.records[i].fields.phone, address: shopList.records[i].fields.address)
                            self.shops.append(shop)
                        }
                        self.shopDics = Dictionary(grouping: self.shops, by: { shops in
                            shops.county
                        })
                        self.counties = self.shopDics.keys.sorted(by: <)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                } else {
                    print("Error")
                }
            }.resume()
        }
    }
    
    @IBAction func phoneCall(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            let section = indexPath.section
            let item = sender.tag
            let county = counties[section]
            let shops = shopDics[county] ?? []
            let shop = shops[item]
            let phoneNumber = shop.phone
            print(section, item, phoneNumber)
            if let url = URL(string: "tel://\(phoneNumber)") {
                UIApplication.shared.open(url)
            }
        }
    }
    
    @IBAction func mapButton(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            let section = indexPath.section
            let item = sender.tag
            let county = counties[section]
            let shops = shopDics[county] ?? []
            let shop = shops[item]
            let address = shop.address
            print(address)
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(address) { placemarks, error in
                guard error == nil else {
                    let alert = UIAlertController(title: "轉換問題", message: "地址錯誤！", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "確定", style: .destructive)
                    alert.addAction(okAction)
                    self.present(alert, animated: true)
                    return
                }
                guard placemarks != nil else {
                    let alert = UIAlertController(title: "轉換問題", message: "地址轉換經緯度失敗！", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "確定", style: .destructive)
                    alert.addAction(okAction)
                    self.present(alert, animated: true)
                    return
                }
                if !placemarks!.isEmpty {
                    let toPlacemark = placemarks!.first!
                    let toPin = MKPlacemark(placemark: toPlacemark)
                    print("經度：\(toPin.coordinate.longitude)，緯度：\(toPin.coordinate.latitude)")
                    let destMapItem = MKMapItem(placemark: toPin)
                    let option = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                    destMapItem.openInMaps(launchOptions: option)
                } else {
                    let alert = UIAlertController(title: "轉換問題", message: "沒有取得導航用的經緯度！", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "確定", style: .destructive)
                    alert.addAction(okAction)
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return counties.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return counties[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopTableViewCell", for: indexPath) as! ShopTableViewCell
        let county = counties[indexPath.section]
        cell.shops = shopDics[county] ?? []
        cell.collectionView.tag = indexPath.section
        cell.collectionView.reloadData()
        return cell
    }
}
