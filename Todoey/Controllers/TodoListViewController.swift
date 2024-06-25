//  ToDoListViewController.swift
//
//  Todoey
//
//  Created by Ömer Yılmaz on 25.06.2024.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!  // Arama çubuğu IBOutlet bağlantısı
    
    var toDoItems: Results<Item>?  // Yapılacaklar listesi öğelerini tutan değişken
    let realm = try! Realm()  // Realm veritabanı örneği
    var selectedCategory: Category? {  // Seçilen kategori
        didSet {
            loadItems()  // Kategori seçildiğinde öğeleri yükle
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none  // Tablo ayırıcı çizgilerini kaldır
    }
    
    // Görünüm ekrana gelmeden önce çağrılır. Navigasyon çubuğunun ve arama çubuğunun stilini ayarlar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let _ = selectedCategory?.colour {  // Seçilen kategorinin rengi varsa
            title = selectedCategory!.name  // Başlığı kategori ismi yap
            guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.") }// Navigasyon çubuğunu kontrol et
            
            let appearance = UINavigationBarAppearance()  // Navigasyon çubuğu görünümü
            appearance.backgroundColor = .systemBlue  // Arka plan rengini ayarla
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]  // Büyük başlık metin rengi
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]  // Başlık metin rengi
            
            navBar.standardAppearance = appearance  // Standart görünüm
            navBar.compactAppearance = appearance  // Kompakt görünüm
            navBar.scrollEdgeAppearance = appearance  // Kaydırma kenarı görünümü
            navBar.tintColor = .white  // Navigasyon çubuğu ögeleri rengi
            searchBar.barTintColor = .systemBlue  // Arama çubuğu arka plan rengi
        }
    }
    
    // Mark: - Tableview Datasource Methods
    
    // Tablo görünümü için veri sağlar. Hücrelerin sayısını ve içeriğini belirler
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1  // Öğelerin sayısını döndür, yoksa 1 döndür
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)  // Hücreyi oluştur
        if let item = toDoItems?[indexPath.row] {  // Öğeyi al
            cell.textLabel?.text = item.title  // Hücre metnini ayarla
            cell.backgroundColor = .systemBlue  // Hücre arka plan rengini ayarla
            cell.textLabel?.textColor = .white  // Metin rengini ayarla
            cell.tintColor = .white  // Tik işaretinin rengini ayarla
            cell.accessoryType = item.done ? .checkmark : .none  // Yapıldı işaretini ayarla
        } else {
            cell.textLabel?.text = "No Items Added"  // Öğeler yoksa metni ayarla
            cell.accessoryType = .none  // Yapıldı işaretini kaldır
        }
        
        return cell  // Hücreyi döndür
    }
    
    // Mark: - TableView Delegate Methods
    
    // Bir tablo hücresi seçildiğinde çağrılır. Öğenin yapılma durumunu değiştirir ve tabloyu günceller
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {  // Seçilen öğeyi al
            do {
                try realm.write {  // Realm veritabanına yaz
                    item.done = !item.done  // Yapıldı durumunu değiştir
                }
            } catch {
                print("Error saving done status, \(error)")  // Hata varsa yazdır
            }
        }
        
        tableView.reloadData()  // Tabloyu yeniden yükle
        tableView.deselectRow(at: indexPath, animated: true)  // Seçimi kaldır
    }
    
    // Yeni bir yapılacak öğe eklemek için kullanılan butonun aksiyonunu tanımlar. Kullanıcıdan yeni öğe bilgisini almak için bir uyarı gösterir ve yeni öğeyi veritabanına ekler
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()  // Yeni öğe için metin alanı
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)  // Alert oluştur
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in  // Ekleme butonu
            if let currentCategory = self.selectedCategory {  // Geçerli kategori
                do {
                    try self.realm.write {  // Realm veritabanına yaz
                        let newItem = Item()  // Yeni öğe oluştur
                        newItem.title = textField.text!  // Öğenin başlığını ayarla
                        newItem.dateCreated = Date()  // Oluşturulma tarihini ayarla
                        currentCategory.items.append(newItem)  // Öğeyi kategoriye ekle
                    }
                } catch {
                    print("Error saving new items, \(error)")  // Hata varsa yazdır
                }
            }
            self.tableView.reloadData()  // Tabloyu yeniden yükle
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in  // İptal butonu
            alert.dismiss(animated: true, completion: nil)  // Alert'i kapat
        }

        alert.addTextField { (alertTextField) in  // Alert'e metin alanı ekle
            alertTextField.placeholder = "Create new item"  // Placeholder metni
            textField = alertTextField  // Metin alanını değişkene ata
        }
        alert.addAction(action)  // Ekleme butonunu alert'e ekle
        alert.addAction(cancelAction)  // İptal butonunu alert'e ekle
        present(alert, animated: true, completion: nil)  // Alert'i göster
    }
    
    // Mark: - Model Manipulation Methods
    
    // Seçilen kategoriye ait yapılacak öğeleri yükler ve tabloyu günceller
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)  // Öğeleri yükle ve sırala
        tableView.reloadData()  // Tabloyu yeniden yükle
    }
    
    // Bir öğeyi silmek için kullanılan metod. Öğeyi veritabanından kaldırır.
    override func updateModel(at indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {  // Silinecek öğeyi al
            do {
                try realm.write {  // Realm veritabanından sil
                    realm.delete(item)  // Öğeyi sil
                }
            } catch {
                print("Error deleting item, \(error)")  // Hata varsa yazdır
            }
        }
    }
}

// Mark: - Searchbar delegate methods
extension TodoListViewController: UISearchBarDelegate {
        
    // Arama çubuğundaki metin değiştiğinde çağrılır. Öğeleri arama terimine göre filtreler ve tabloyu günceller.

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {  // Arama metni boşsa
            loadItems()  // Tüm öğeleri yükle
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()  // Arama çubuğunu kapat
            }
        } else {
            toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)// Öğeleri filtrele ve sırala
            tableView.reloadData()  // Tabloyu yeniden yükle
        }
    }
}
