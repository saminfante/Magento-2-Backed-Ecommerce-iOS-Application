//
//  ProductDetailViewController.swift
//  Magenta Square Demo
//
//  Created by Work on 1/26/19.
//  Copyright © 2019 TheMysteryPuzzles. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {

    var selectedAttributes: CustomAttributes!
    var sizeSum = 0.0
    var baseSizeSum = 0.0
    var cartId: Int?{
        didSet{
            let defaults = UserDefaults.standard
            defaults.set("\(cartId!)", forKey: "cartId")
        }
    }
    var quantity = 1
    var cartInformation: CartInformationJSONModel?
    
    var selectedItem: Item?
    var basePrice: Double?
    var model: ProductDetailModel?
    var customOptionsModel:CustomOptionSkuCustomOptionsModel?
    lazy var colorCodes = [String]()
    var sum = 0.0
   
    var widthInchesDropdown = [String]()
    var heightInchesDropdown = [String]()
    var widthInchesDecimalDropdown = [String]()
    var heightInchesDecimalDropdown = [String]()
    
    var width1 = 0.0
    var width2 = 0.0
    var height1 = 0.0
    var height2 = 0.0
    
    
   /* let widthCmDropdown = DropDown()
    let heightCmDropdown = DropDown()
    let widthCmDecimalDropdown = DropDown()
    let heightCmDecimalDropdown = DropDown()*/
 
    
    func handlePlayVideoTapped(){
        let controller = VideoPlayerViewController()
       self.navigationController?.pushViewController(controller, animated: true)
    }
    
    lazy var productDetailView: ProductDetailView = {
       let view = ProductDetailView(frame: self.view.bounds)
        view.delegate = self
        view.productDetailViewController = self
        view.selectColorCollectionView.dataSource = self
         view.selectColorCollectionView.delegate = self
       return view
    }()

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
  
    override func viewWillDisappear(_ animated: Bool) {
         self.navigationController?.navigationBar.isHidden = false
    }
 
    override func viewDidAppear(_ animated: Bool) {
        self.productDetailView.scrollView.contentSize.height = self.productDetailView.selectOperationsView.frame.maxY //self.productDetailView.roomNameTextField.frame.maxY
        
          self.productDetailView.cartAndRate.addBlurEffect()
        self.productDetailView.cartAndRate.bringSubviewToFront( self.productDetailView.rateLabel)
        self.productDetailView.cartAndRate.bringSubviewToFront( self.productDetailView.rateValueLabel)
       
        self.productDetailView.cartAndRate.bringSubviewToFront( self.productDetailView.cancelButton)
        self.productDetailView.cartAndRate.bringSubviewToFront( self.productDetailView.addToCartButton)
    }
    
    private func setupDropDowns(){

        for option in  self.customOptionsModel!.options!{
            
            if option.sortOrder == 3 {
                for value in option.values! {
                    
                    self.widthInchesDropdown.append(value.title!)
                   
                }
                self.productDetailView.widthInchesDropdown.bottomOffset = CGPoint(x: 0, y: 10)
                self.productDetailView.widthInchesDropdown.dataSource = self.widthInchesDropdown
                
                self.productDetailView.widthInchesDropdown.selectionAction = { [weak self] (index, item) in
                    self!.productDetailView.widthTextField.setTitle(item, for: .normal)
                    if self?.width1 == 0 {
                        self?.width1 = Double(option.values![index].price!)
                        self?.sizeSum += option.values![index].price!
                        
                        let finalPrice = self!.basePrice! + self!.sizeSum
                        self!.productDetailView.rateValueLabel.text = "AED " + "\(finalPrice)"
                    }else{
                        
                        self!.sizeSum -= self!.width1
                        self?.width1 = option.values![index].price!
                        self?.sizeSum += option.values![index].price!
                        
                        let finalPrice = self!.basePrice! + self!.sizeSum
                        self!.productDetailView.rateValueLabel.text = "AED " + "\(finalPrice)"
                        
                    }
                  
            }
        } else if option.sortOrder == 4 {
                for value in option.values! {
                   print("\(value.title): \(value.price)")
                    self.widthInchesDecimalDropdown.append(value.title!)
                  
                }
                self.productDetailView.widthInchesDecimalDropdown.bottomOffset = CGPoint(x: 0, y: 10)
                self.productDetailView.widthInchesDecimalDropdown.dataSource = self.widthInchesDecimalDropdown
                
                self.productDetailView.widthInchesDecimalDropdown.selectionAction = { [weak self] (index, item) in
                    self!.productDetailView.widthTextFieldDecimal.setTitle(item, for: .normal)
                    if self?.width2 == 0 {
                        self?.width2 = option.values![index].price!
                        self?.sizeSum += option.values![index].price!
                        
                        let finalPrice = self!.basePrice! + self!.sizeSum
                        self!.productDetailView.rateValueLabel.text = "AED " + "\(finalPrice)"
                    }else{
                        
                        self!.sizeSum -= self!.width2
                        self?.width2 = option.values![index].price!
                        self?.sizeSum += option.values![index].price!
                        
                        let finalPrice = self!.basePrice! + self!.sizeSum
                        self!.productDetailView.rateValueLabel.text = "AED " + "\(finalPrice)"
                        
                    }
          
                }
            }else if option.sortOrder == 6 {
                for value in option.values! {
                  //  print("\(value.title): \(value.price)")
                    self.heightInchesDropdown.append(value.title!)
                }
                self.productDetailView.heightInchesDropdown.bottomOffset = CGPoint(x: 0, y: 10)
                self.productDetailView.heightInchesDropdown.dataSource = self.heightInchesDropdown
                
                self.productDetailView.heightInchesDropdown.selectionAction = { [weak self] (index, item) in
                    self!.productDetailView.heightTextField.setTitle(item, for: .normal)
                    if self?.height1 == 0 {
                        self?.height1 = option.values![index].price!
                        self?.sizeSum += option.values![index].price!
                        
                        let finalPrice = self!.basePrice! + self!.sizeSum
                        self!.productDetailView.rateValueLabel.text = "AED " + "\(finalPrice)"
                    }else{
                        
                        self!.sizeSum -= self!.height1
                        self?.height1 = option.values![index].price!
                        self?.sizeSum += option.values![index].price!
                        
                        let finalPrice = self!.basePrice! + self!.sizeSum
                        self!.productDetailView.rateValueLabel.text = "AED " + "\(finalPrice)"
                        
                    }
                }
            } else if option.sortOrder == 7 {
                for value in option.values! {
                    
                    self.heightInchesDecimalDropdown.append(value.title!)
                }
                self.productDetailView.heightInchesDecimalDropdown.bottomOffset = CGPoint(x: 0, y: 10)
                self.productDetailView.heightInchesDecimalDropdown.dataSource = self.heightInchesDecimalDropdown
                
                self.productDetailView.heightInchesDecimalDropdown.selectionAction = { [weak self] (index, item) in
                    self!.productDetailView.heightTextFieldDecimal.setTitle(item, for: .normal)
                    if self?.height2 == 0 {
                        self?.height2 = option.values![index].price!
                        self?.sizeSum += option.values![index].price!
                        
                        let finalPrice = self!.basePrice! + self!.sizeSum
                        self!.productDetailView.rateValueLabel.text = "AED " + "\(finalPrice)"
                    }else{
                        
                        self!.sizeSum -= self!.height2
                        self?.height2 = option.values![index].price!
                        self?.sizeSum += option.values![index].price!
                        
                        let finalPrice = self!.basePrice! + self!.sizeSum
                        self!.productDetailView.rateValueLabel.text = "AED " + "\(finalPrice)"
                        
                    }
                }
            }
        
     
    }
   handlePrices()
}
    
    private func handlePrices(){
        self.productDetailView.rateValueLabel.text = "AED" + String(self.selectedItem!.price!)
        self.sum = 0
        self.basePrice = 0
    }
    
    
    func handleAddToCart(){
        let alertController = UIAlertController(title: "Item Added", message: "Your selected item along with its customization options has been added to cart", preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "CheckOut", style: .default) { (action:UIAlertAction!) in
         
            let controller = CheckoutViewController()
            self.present(controller, animated: true, completion: nil)
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped");
            
        }
        alertController.addAction(OKAction)
        
        // Create Cancel button
        let cancelAction = UIAlertAction(title: "Back", style: .cancel) { (action:UIAlertAction!) in
           alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
         self.present(alertController, animated: true, completion:nil)
        //createACartForLoggedInCustomer()
    }
    
    
    private func getCustomOptionOfSelectedProduct(){
        
        print("\(selectedItem!.sku)")
        
        var request = URLRequest(url: URL(string: hostName+"/rest/V1/products/"+"\(selectedItem!.sku!)")!)
        
        print("\(request)")
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer "+adminToken!, forHTTPHeaderField:
            "Authorization")
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(CustomOptionSkuCustomOptionsModel.self, from: data!)
                self.customOptionsModel = responseModel
                DispatchQueue.main.async {
                     self.getAllCustomOptions()
                }
               
            } catch {
                print("JSON Serialization error")
            }
        }).resume()
        
    }
    
    
    private func getAllCustomOptions(){
        
        for option in self.customOptionsModel!.options!{
           
            
            
            if option.title! == "Colors:" {
                for value in option.values!{
                    self.colorCodes.append(value.title!)
                }
                DispatchQueue.main.async {
                      self.productDetailView.selectColorCollectionView.reloadData()
                }
                
            }
        }
        setupDropDowns()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productDetailView.productNameLabel.text = self.selectedItem?.name!
          getCustomOptionOfSelectedProduct()
        for attr in selectedItem!.customAttributes!{
            if attr.attributeCode == "thumbnail" {
                
                var thumbNailUrl = "\(attr.value.unsafelyUnwrapped)"
                thumbNailUrl = String(thumbNailUrl.dropFirst(8))
                thumbNailUrl = String(thumbNailUrl.dropLast(2))
            if let url = URL(string: webServerDocumentRootUrl + thumbNailUrl){
                self.productDetailView.productImageView.downloadAndSetImage(from: url, contentMode: .scaleAspectFill)
            }
        }
            
            if attr.attributeCode == "description" {
                var text = "\(attr.value.unsafelyUnwrapped)"
                text = String(text.dropFirst(8))
                text = String(text.dropLast(2))
              self.productDetailView.productDetailLabel.text = text
        }
        self.view.addSubview(productDetailView)
        self.handlePrices()
    }
  }
}


extension ProductDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for cell in collectionView.visibleCells {
            let cellView = cell as! ColorCollectionViewCell
            cellView.colorView.backgroundColor = UIColor.clear
        }
        for option in self.customOptionsModel!.options!{
            if option.title! == "Colors:" {
                let price = option.values![indexPath.item].price
                let finalPrice = sum + price!
                self.productDetailView.rateValueLabel.text = "AED " + "\(finalPrice)"
                self.basePrice = price!
            }
        }
      let cell = collectionView.cellForItem(at: indexPath) as! ColorCollectionViewCell
      cell.colorView.backgroundColor = #colorLiteral(red: 0.8504895568, green: 1, blue: 1, alpha: 1)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height * 0.45
        let width  = collectionView.frame.width * 0.3
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return colorCodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ColorCollectionViewCell
        if colorCodes[indexPath.item] == "5085" {
            let url = URL(string: "https://magentasquares.com/pub/media/itoris/files/w/c/wc-12-0013-"+"\(colorCodes[indexPath.item])"+"_100x100.png")
            print("https://magentasquares.com/pub/media/itoris/files/w/c/wc-12-0013-"+"\(colorCodes[indexPath.item])"+".png")
            cell.colorView.image = nil
            if  url != nil{
                cell.colorView.loadImageUsingCache(withUrl: url!)
            }
        }else{
            
        let url = URL(string: "https://magentasquares.com/pub/media/itoris/files/w/c/wc-12-0013-"+"\(colorCodes[indexPath.item])"+"_100x100.png")

         cell.colorView.image = nil
        if  url != nil{
            cell.colorView.loadImageUsingCache(withUrl: url!)
        }
    }
        cell.colorNameLabel.text = colorCodes[indexPath.item]
       
        return cell
    }
}


class ColorCollectionViewCell: UICollectionViewCell {
    
    lazy var colorView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupcolorViewConstraints(){
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: self.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            colorView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.75)
            ])
    }
    
    lazy var colorNameLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
       label.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
    private func setupColorNameLabelConstraints(){
        NSLayoutConstraint.activate([
            colorNameLabel.topAnchor.constraint(equalTo: self.colorView.bottomAnchor),
            colorNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            colorNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            colorNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            
            ])
      }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(colorView)
        setupcolorViewConstraints()
        
        self.addSubview(colorNameLabel)
        setupColorNameLabelConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ProductDetailViewController {
  
    private func createACartForLoggedInCustomer(){
        var request = URLRequest(url: URL(string: hostName+"/rest/default/V1/carts/mine")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer "+customerToken, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            // print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Int
                print("New Cart Created")
                print("Cart ID: \(json)")
                self.cartId = json
            } catch {
                print("\(error)")
            }
        })
        
        task.resume()
    }
    
    private func addItemToTheCart(){
        
        let params = ["cartItem": ["sku": selectedItem!.sku!,"qty": quantity,"quote_id": cartId!]]
        
        var request = URLRequest(url: URL(string: hostName+"/rest/default/V1/carts/mine/items")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer "+customerToken, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            // print(response!)
            do {
                
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(AddItemToCartJSONModel.self, from: data!)
                print("Details Of Products Added To Cart")
                print(responseModel.productType!)
                print(responseModel.name!)
                //self.getCartTotalCost()
                self.setShippingInformation()
                
            } catch {
                print("\(error)")
            }
        })
        task.resume()
    }
    
    
    private func getSelectedItemInformation(){
        var request = URLRequest(url: URL(string: hostName+"/rest/V1/carts/mine/")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer "+customerToken, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(CartInformationJSONModel.self, from: data!)
                self.cartInformation = responseModel
                
                if self.cartInformation?.itemsCount != nil{
                    //self.addToCartView.emptyCartLabel.isHidden = true
                }
                self.addItemToTheCart()
                
                //   self.setShippingInformation()
                
            } catch {
                print("JSON Serialization error")
            }
        }).resume()
    }
    
    private func getLoggedInCustomerCartInformation(){
        var request = URLRequest(url: URL(string: hostName+"/rest/V1/carts/mine/")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer "+customerToken, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(CartInformationJSONModel.self, from: data!)
                self.cartInformation = responseModel
                
                if self.cartInformation?.itemsCount != nil{
                    //self.addToCartView.emptyCartLabel.isHidden = true
                }
                self.addItemToTheCart()
                
                //   self.setShippingInformation()
                
            } catch {
                print("JSON Serialization error")
            }
        }).resume()
    }
    
    
    private func getCartTotalCost(){
        var request = URLRequest(url: URL(string: hostName+"/rest/V1/carts/mine/totals")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer "+customerToken, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(CartGrandTotalJSONModel.self, from: data!)
                
                print("GrandTotal :"+"\(responseModel.grandTotal)")
                self.setShippingInformation()
                
            } catch {
                print("JSON Serialization error")
            }
        }).resume()
    }
    
    private func setShippingInformation(){
        let params = [
            "cartId": cartId!,
            "address": [
                "region": "New York",
                "region_id": 43,
                "region_code": "NY",
                "country_id": "US",
                "street": [
                    "123 Oak Ave"
                ],
                "postcode": "10577",
                "city": "Purchase",
                "firstname": "Jane",
                "lastname": "Doe",
                "customer_id": customerId!,
                "email": "jdoe@example.com",
                "telephone": "(512) 555-1111",
                "same_as_billing": 0
            ],
            "useForShipping": true
            ] as [String : Any]
        
        var request = URLRequest(url: URL(string: hostName+"/rest/V1/carts/mine/billing-address")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer "+customerToken, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            // print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! String
                print("Shipping Adress ID: "+json)
                
                //  self.setPaymentInformationAndPlaceNewOrder()
            } catch {
                print("\(error)")
            }
        })
        task.resume()
    }
    
    private func setPaymentInformationAndPlaceNewOrder(){
        let params =  [
            "paymentMethod": [
                "poNumber": "1",
                "method": "cashondelivery"
            ],
            "billingAddress": [
                "id": 60,
                "region": "Arkansas",
                "regionId": 5,
                "regionCode": "AR",
                "countryId": "US",
                "street": [
                    "Whitefield,New York"
                ],
                "company": "IBM",
                "telephone": "94354545",
                "postcode": "234533",
                "city": "New York",
                "firstname": "Hello",
                "lastname": "Again",
                "prefix": "address_",
                "customerId": customerId!,
                "email": "junaidiqbalturk@gmail.com",
                "sameAsBilling": 0,
                "customerAddressId": 0,
                "saveInAddressBook": 1
            ]
            ] as [String : Any]
        
        var request = URLRequest(url: URL(string: hostName+"/rest/V1/carts/mine/payment-information")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer "+customerToken, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            // print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! String
                print("Order ID: "+json)
            } catch {
                print("\(error)")
            }
        })
        task.resume()
    }
    
   /* override func viewDidLoad() {
        super.viewDidLoad()
        
        /* self.view.addSubview(addToCartView)
         self.addToCartView.emptyCartLabel.isHidden = true
         let cartId = defaults.string(forKey: "cartId")
         if cartId == nil{
         self.addToCartView.emptyCartLabel.isHidden = false
         createACartForLoggedInCustomer()
         }else{
         getLoggedInCustomerCartInformation()
         }*/
    }*/
}

