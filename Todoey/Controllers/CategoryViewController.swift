//
//  CategoryViewController.swift
//
//  Todoey
//
//  Created by Ömer Yılmaz on 4.06.2024.
//

import UIKit
import RealmSwift

// CategoryViewController sınıfı, SwipeTableViewController sınıfından miras alır
class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()  // Realm veritabanı örneği oluşturulur
    
    var categories: Results<Category>?  // Category sonuçları için bir değişken
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()  // Kategorileri yükle
        tableView.separatorStyle = .none  // Tablo görünümünde ayırıcı çizgileri kaldır
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.") }  // Navigasyon çubuğunun varlığını kontrol et
        
        let appearance = UINavigationBarAppearance()  // Navigasyon çubuğu görünümünü ayarla
        appearance.backgroundColor = .systemTeal  // Arka plan rengi
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]  // Büyük başlık metin rengi
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]  // Başlık metin rengi
        
        navBar.standardAppearance = appearance  // Standart görünüm
        navBar.compactAppearance = appearance  // Kompakt görünüm
        navBar.scrollEdgeAppearance = appearance  // Kaydırma kenarı görünümü
        navBar.tintColor = .white  // Navigasyon çubuğu ögelerinin rengi
    }
    
    // Mark: - Tableview Datasource Methods
    // Tablo görünümünde kaç satır olacağını belirler.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1  // Kategori sayısını döndür veya 1 döndür
    }
    
    // Her bir hücreyi oluşturur ve gerekli verilerle doldurur.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)  // Hücreyi oluştur
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"  // Hücre metnini ayarla
        
        if (categories?[indexPath.row]) != nil {  // Kategori mevcutsa
            cell.backgroundColor = .systemTeal  // Hücre arka plan rengini ayarla
            cell.textLabel?.textColor = .white  // Hücre metin rengini ayarla
        }
        return cell  // Hücreyi döndür
    }
    
    // Mark: - Data Manipulation Methods
    // Yeni bir kategori kaydeder ve tabloyu günceller.
    func save(category: Category) {
        do {
            try realm.write {  // Realm veritabanına yaz
                realm.add(category)  // Yeni kategoriyi ekle
            }
        } catch {
            print("Error saving category \(error)")  // Hata varsa yazdır
        }
        tableView.reloadData()  // Tabloyu yeniden yükle
    }
    
    // Realm veritabanından kategorileri yükler ve tabloyu günceller.
    func loadCategories() {
        categories = realm.objects(Category.self)  // Kategorileri yükle
        tableView.reloadData()  // Tabloyu yeniden yükle
    }
    
    // Mark: - Delete Data from Swipe
    // Bir kategori silinmek üzere seçildiğinde çağrılır ve ilgili kategoriyi veritabanından siler.
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {  // Silinecek kategoriyi bul
            do {
                try self.realm.write {  // Realm veritabanından sil
                    self.realm.delete(categoryForDeletion)  // Kategoriyi sil
                }
            } catch {
                print("Error deleting category, \(error)")  // Hata varsa yazdır
            }
        }
    }
    
    // Mark: - Add New Categories
    // "Add" butonuna basıldığında çağrılan fonksiyon. Yeni bir kategori eklemek için bir alert gösterir.
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()  // Yeni kategori ismi için textfield
        
        let alert = UIAlertController(title: "Add a New Category", message: "", preferredStyle: .alert)  // Alert oluştur
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in  // Ekleme butonu
            let newCategory = Category()  // Yeni kategori oluştur
            newCategory.name = textField.text!  // Kategori ismini ayarla
            newCategory.colour = "HG3412"  // Kategori rengini ayarla
            self.save(category: newCategory)  // Yeni kategoriyi kaydet
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in  // İptal butonu
            alert.dismiss(animated: true, completion: nil)  // Alert'i kapat
        }
        
        alert.addAction(addAction)  // Ekleme butonunu alert'e ekle
        alert.addAction(cancelAction)  // İptal butonunu alert'e ekle
        
        alert.addTextField { (field) in  // Textfield'i alert'e ekle
            textField = field  // Textfield'i değişkene ata
            textField.placeholder = "Add a new category"  // Placeholder metni
        }
        
        present(alert, animated: true, completion: nil)  // Alert'i göster
    }
    
    // Mark: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)  // Seçilen kategoriyle segue yap
    }
    
    // Segue yapılırken çağrılır. Hedef view controller'a veriler aktarılır.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController  // Hedef view controller
        if let indexPath = tableView.indexPathForSelectedRow {  // Seçilen satırın index path'i
            destinationVC.selectedCategory = categories?[indexPath.row]  // Seçilen kategoriyi hedef view controller'a ata
        }
    }
}
