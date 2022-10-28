//
//  MenuTableViewController.swift
//  DrinksOrder
//
//  Created by doriswlc on 2022/10/12.
//

import UIKit
import Kingfisher

class MenuTableViewController: UITableViewController {
    
    lazy var filteredDrinks = [Record]()
    @IBOutlet weak var typeSegment: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    var drinksAll = [Record]()
    var drinks1 = [Record]()
    var drinks2 = [Record]()
    var drinks3 = [Record]()
    var drinks4 = [Record]()
    var drinks5 = [Record]()
    var drinks6 = [Record]()
    var index = 0
        
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
                            self.drinksAll = drinkMenu.records
                            for drink in self.drinksAll {
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
                            self.filteredDrinks = self.drinks1
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
    func search(_ searchTerm: String) {
        var currentDrink = [Record]()
        switch index {
        case 0:
            currentDrink = drinks1
        case 1:
            currentDrink = drinks2
        case 2:
            currentDrink = drinks3
        case 3:
            currentDrink = drinks4
        case 4:
            currentDrink = drinks5
        case 5:
            currentDrink = drinks6
        default:
            break
        }
        if searchTerm.isEmpty {
            filteredDrinks = currentDrink
        } else {
            filteredDrinks = currentDrink.filter({ $0.fields.drinkname.contains(searchTerm)
            })
        }
        tableView.reloadData()
    }
        
    @IBAction func changeType(_ sender: UISegmentedControl) {
        index = sender.selectedSegmentIndex
        switch index {
        case 0:
            if searchBar.text == "" {
                filteredDrinks = drinks1
            } else {
                filteredDrinks = drinks1.filter({ $0.fields.drinkname.contains(searchBar.text!)
                })
            }
        case 1:
            if searchBar.text == "" {
                filteredDrinks = drinks2
            } else {
                filteredDrinks = drinks2.filter({ $0.fields.drinkname.contains(searchBar.text!)
                })
            }
        case 2:
            if searchBar.text == "" {
                filteredDrinks = drinks3
            } else {
                filteredDrinks = drinks3.filter({ $0.fields.drinkname.contains(searchBar.text!)
                })
            }
        case 3:
            if searchBar.text == "" {
                filteredDrinks = drinks4
            } else {
                filteredDrinks = drinks4.filter({ $0.fields.drinkname.contains(searchBar.text!)
                })
            }
        case 4:
            if searchBar.text == "" {
                filteredDrinks = drinks5
            } else {
                filteredDrinks = drinks5.filter({ $0.fields.drinkname.contains(searchBar.text!)
                })
            }
        case 5:
            if searchBar.text == "" {
                filteredDrinks = drinks6
            } else {
                filteredDrinks = drinks6.filter({ $0.fields.drinkname.contains(searchBar.text!)
                })
            }
        default:
            break
        }
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDrinks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(DrinkTableViewCell.self)", for: indexPath) as! DrinkTableViewCell
        let drink = filteredDrinks[indexPath.row]
        cell.nameLabel.text = drink.fields.drinkname
        cell.ihLabel.text = ""
        for i in 0..<drink.fields.ih.count {
            cell.ihLabel.text! += "\t\(drink.fields.ih[i])\t"
        }
        cell.sizeLabel.text = ""
        for i in 0..<drink.fields.size.count {
            cell.sizeLabel.text! += "\t\(drink.fields.size[i])\t"
        }
        cell.priceLabel.text = ""
        for i in 0..<drink.fields.price.count {
            cell.priceLabel.text! += "\t\(drink.fields.price[i])\t"
        }
        cell.picImageView.kf.setImage(with: drink.fields.picture[0].url)
        return cell
    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? OrderTableViewController, let row = tableView.indexPathForSelectedRow?.row {
            controller.drinkSelected = filteredDrinks[row].fields
        }
    }
}

extension MenuTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchTerm = searchBar.text ?? ""
        search(searchTerm)
        searchBar.resignFirstResponder()
    }
}

