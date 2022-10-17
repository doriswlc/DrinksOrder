//
//  MenuTableViewController.swift
//  DrinksOrder
//
//  Created by doriswlc on 2022/10/12.
//

import UIKit
import Kingfisher

class MenuTableViewController: UITableViewController {
    @IBOutlet weak var typeSegment: UISegmentedControl!
    var drinks = [Record]()
    var drinks1 = [Record]()
    var drinks2 = [Record]()
    var drinks3 = [Record]()
    var drinks4 = [Record]()
    var drinks5 = [Record]()
    var drinks6 = [Record]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchdrink()
    }
    
    func fetchdrink() {
        if let url = URL(string: "https://api.airtable.com/v0/appWKQiePYTFRgmRM/Menu") {
            var request = URLRequest(url: url)
            request.setValue("Bearer keySfV0P5ClR74OTq", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, response , error in
                if let data {
                    do {
                        let decoder = JSONDecoder()
                        let drinkMenu = try decoder.decode(DrinkMenu.self, from: data)
                        DispatchQueue.main.async {
                            self.drinks = drinkMenu.records
                            for drink in self.drinks {
                                switch drink.fields.type {
                                case "醇茶":
                                    self.drinks1.append(drink)
                                case "奶茶":
                                    self.drinks2.append(drink)
                                case "鮮奶":
                                    self.drinks3.append(drink)
                                case "奶霜":
                                    self.drinks4.append(drink)
                                case "農摘":
                                    self.drinks5.append(drink)
                                case "季節限定":
                                    self.drinks6.append(drink)
                                default:
                                    break
                                }
                            }

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
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch typeSegment.selectedSegmentIndex {
        case 0:
            return drinks1.count
        case 1:
            return drinks2.count
        case 2:
            return drinks3.count
        case 3:
            return drinks4.count
        case 4:
            return drinks5.count
        default:
            return drinks6.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(DrinkTableViewCell.self)", for: indexPath) as! DrinkTableViewCell
        var drink: Record
        switch typeSegment.selectedSegmentIndex {
        case 0:
            drink = drinks1[indexPath.row]
        case 1:
            drink = drinks2[indexPath.row]
        case 2:
            drink = drinks3[indexPath.row]
        case 3:
            drink = drinks4[indexPath.row]
        case 4:
            drink = drinks5[indexPath.row]
        default:
            drink = drinks6[indexPath.row]
        }
        cell.nameLabel.text = drink.fields.drinkname
        cell.ihLabel.text = ""
        for i in 0..<drink.fields.size.count {
            cell.ihLabel.text! += "\t\(drink.fields.ih[i])\t"
        }
        cell.sizeLabel.text = ""
        for i in 0..<drink.fields.size.count {
            cell.sizeLabel.text! += "\t\(drink.fields.size[i])\t"
        }
        cell.priceLabel.text = ""
        for i in 0..<drink.fields.size.count {
            cell.priceLabel.text! += "\t\(drink.fields.price[i])"
        }
        cell.picImageView.kf.setImage(with: drink.fields.picture[0].url)
        return cell
    }

//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch typeSegment.selectedSegmentIndex {
//        case 0:
//            return "醇茶"
//        case 1:
//            return "奶茶"
//        case 2:
//            return "鮮奶"
//        case 3:
//            return "奶霜"
//        case 4:
//            return "農摘"
//        default:
//            return "季節限定"
//        }
//    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MenuTableViewController: UISearchBarDelegate {
    
}
