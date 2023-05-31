//
//  AddViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.04.2023.
//

import UIKit

class AddViewController: UIViewController {
    //MARK: - Properties
    var viewModel = AddViewControllerViewModel()
    let scrollView = UIScrollView()
    let contentView = UIView()
    lazy var topView: TopBarView = {
        let view = TopBarView()
        view.delegate = self
        return view
    }()
    var isMainImage: Bool = false
    var index: Int?
    lazy var bestImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "add 1")
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBestImageView)))
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let titleRecipeTeactsField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter name of recipe"
        tf.textAlignment = .center
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let dividerNameView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.placeholder = "Tell us about the dish"
        tv.font = .systemFont(ofSize: 16, weight: .medium)
        tv.textAlignment = .center
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    let dividerDescriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var  categoryView: LabelTextfieldView = {
        let view = LabelTextfieldView(frame: .zero, type: .category)
        view.delegate = self
        return view
    }()
    
    lazy var  quantityView: LabelTextfieldView = {
        let view = LabelTextfieldView(frame: .zero, type: .quantity)
        view.delegate = self
        return view
    }()
    lazy var cookigTimeView: LabelTextfieldView = {
        let view = LabelTextfieldView(frame: .zero, type: .cookingTime)
        view.delegate = self
        return view
    }()
    
    //add ingredients
    let ingredientsTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(AddIngredientTableViewCell.self, forCellReuseIdentifier: AddIngredientTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    lazy var addIgredientButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add ingredient", for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(didTappedAddInstruction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var ingredientTableViewHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    lazy var ingredientNumberOfRows = viewModel.ingregients.count
    
    //The stage of cooking
    let cookingTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(CookingTableViewCell.self, forCellReuseIdentifier: CookingTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    lazy var cookingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add step", for: .normal)
        button.addTarget(self, action: #selector(didTappedAddStep), for: .touchUpInside)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var cookingTableViewHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    lazy var cookingNumberOfRows = viewModel.instructions.count
    
    //MARK: - Lilecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        contentView.addSubview(topView)
        contentView.addSubview(bestImageView)
        contentView.addSubview(titleRecipeTeactsField)
        contentView.addSubview(dividerNameView)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(dividerDescriptionView)
        contentView.addSubview(categoryView)
        contentView.addSubview(quantityView)
        contentView.addSubview(cookigTimeView)
        
        //add ingredients
        contentView.addSubview(ingredientsTableView)
        contentView.addSubview(addIgredientButton)
        
        //The stage of cooking
        contentView.addSubview(cookingTableView)
        contentView.addSubview(cookingButton)
        
        addConstraints()
        setupBasicUI()
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        calculateIngredientTableViewHeight()
        
        cookingTableView.delegate = self
        cookingTableView.dataSource = self
        calculateCookingTableViewHeight()
    }
    //MARK: - Functions
    private func addConstraints() {
        let topViewConstraints = [
            topView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            topView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            topView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            topView.heightAnchor.constraint(equalToConstant: 50),
        ]
        
        NSLayoutConstraint.activate(topViewConstraints)
        let bestImageViewConstraints = [
            bestImageView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            bestImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            bestImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            bestImageView.heightAnchor.constraint(equalToConstant: 250)
        ]
        NSLayoutConstraint.activate(bestImageViewConstraints)
        let titleRecipeTeactsFieldConstraints = [
            titleRecipeTeactsField.topAnchor.constraint(equalTo: bestImageView.bottomAnchor, constant: 20),
            titleRecipeTeactsField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            titleRecipeTeactsField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            titleRecipeTeactsField.heightAnchor.constraint(equalToConstant: 50)
            
        ]
        NSLayoutConstraint.activate(titleRecipeTeactsFieldConstraints)
        
        let dividerNameViewConstraints = [
            dividerNameView.topAnchor.constraint(equalTo: titleRecipeTeactsField.bottomAnchor),
            dividerNameView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            dividerNameView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            dividerNameView.heightAnchor.constraint(equalToConstant: 2)
        ]
        NSLayoutConstraint.activate(dividerNameViewConstraints)
        
        let descriptionTextViewConstraints = [
            descriptionTextView.topAnchor.constraint(equalTo: dividerNameView.bottomAnchor),
            descriptionTextView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            descriptionTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 150)
            
        ]
        NSLayoutConstraint.activate(descriptionTextViewConstraints)
        
        let dividerDescriptionViewConstraints = [
            dividerDescriptionView.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor),
            dividerDescriptionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            dividerDescriptionView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            dividerDescriptionView.heightAnchor.constraint(equalToConstant: 2),
        ]
        NSLayoutConstraint.activate(dividerDescriptionViewConstraints)
        let categoryViewConstraints = [
            categoryView.topAnchor.constraint(equalTo: dividerDescriptionView.bottomAnchor),
            categoryView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            categoryView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            categoryView.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(categoryViewConstraints)
        let quantityViewConstraints = [
            quantityView.topAnchor.constraint(equalTo: categoryView.bottomAnchor),
            quantityView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            quantityView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            quantityView.heightAnchor.constraint(equalToConstant: 50),
        ]
        NSLayoutConstraint.activate(quantityViewConstraints)
        let cookigTimeViewConstraints = [
            cookigTimeView.topAnchor.constraint(equalTo: quantityView.bottomAnchor),
            cookigTimeView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            cookigTimeView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            cookigTimeView.heightAnchor.constraint(equalToConstant: 50),
        ]
        NSLayoutConstraint.activate(cookigTimeViewConstraints)
        
        //add ingredients
        ingredientTableViewHeightConstraint = ingredientsTableView.heightAnchor.constraint(equalToConstant: 0)
        
        let tableViewConstraints: [NSLayoutConstraint] = [
            ingredientsTableView.topAnchor.constraint(equalTo: cookigTimeView.bottomAnchor),
            ingredientsTableView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            ingredientsTableView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            ingredientTableViewHeightConstraint
        ]
        NSLayoutConstraint.activate(tableViewConstraints)
        
        let addIgredientButtonConstants = [
            addIgredientButton.topAnchor.constraint(equalTo: ingredientsTableView.bottomAnchor),
            addIgredientButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            addIgredientButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            addIgredientButton.heightAnchor.constraint(equalToConstant: 50),
        ]
        NSLayoutConstraint.activate(addIgredientButtonConstants)
        
        //The stage of cooking
        cookingTableViewHeightConstraint = cookingTableView.heightAnchor.constraint(equalToConstant: 0)
        
        let cookingTableViewConstraints: [NSLayoutConstraint] = [
            cookingTableView.topAnchor.constraint(equalTo: addIgredientButton.bottomAnchor),
            cookingTableView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            cookingTableView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            cookingTableViewHeightConstraint
        ]
        NSLayoutConstraint.activate(cookingTableViewConstraints)
        
        let cookingButtonConstants = [
            cookingButton.topAnchor.constraint(equalTo: cookingTableView.bottomAnchor),
            cookingButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            cookingButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            cookingButton.heightAnchor.constraint(equalToConstant: 50),
            cookingButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(cookingButtonConstants)
    }
    private func calculateIngredientTableViewHeight() {
        let totalRowHeight = CGFloat(viewModel.ingregients.count) * (AddIngredientTableViewCell.height)
        ingredientTableViewHeightConstraint.constant = totalRowHeight
    }
    private func calculateCookingTableViewHeight() {
        let totalRowHeight = CGFloat(viewModel.instructions.count) * (CookingTableViewCell.height)
        cookingTableViewHeightConstraint.constant = totalRowHeight
    }
    private func setupBasicUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = viewModel.title
        view.backgroundColor = .systemBackground
    }
    func setupScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    @objc func didTapBestImageView() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        isMainImage = true
    }
    @objc private func didTappedAddInstruction() {
        viewModel.addOneInfredient()
        DispatchQueue.main.async {
            self.calculateIngredientTableViewHeight()
            self.ingredientsTableView.reloadData()
        }
    }
    @objc private func didTappedAddStep() {
        viewModel.addInstructions()
        DispatchQueue.main.async {
            self.calculateCookingTableViewHeight()
            self.cookingTableView.reloadData()
        }
    }
}


//MARK: -  add ingredients table extention
extension AddViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == ingredientsTableView ? viewModel.ingregients.count : viewModel.instructions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ingredientsTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddIngredientTableViewCell.identifier, for: indexPath) as? AddIngredientTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            
            cell.configure(viewModel: viewModel.ingregients[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CookingTableViewCell.identifier, for: indexPath) as? CookingTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.configure(viewModel: viewModel.instructions[indexPath.row])
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView ==  ingredientsTableView ? AddIngredientTableViewCell.height : CookingTableViewCell.height
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)

        if let index = tableView.indexPath(for: cell!)?.row {
            self.index = index
        }

    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        if tableView == cookingTableView {
            self.viewModel.instructions.remove(at: indexPath.row)
            DispatchQueue.main.async {
                self.cookingTableView.deleteRows(at: [indexPath], with: .left)
                self.calculateCookingTableViewHeight()
            }
        } else if tableView == ingredientsTableView {
            
            self.viewModel.ingregients.remove(at: indexPath.row)
            DispatchQueue.main.async {
                self.ingredientsTableView.deleteRows(at: [indexPath], with: .left)
                self.calculateIngredientTableViewHeight()
            }
        }
    }
}





//MARK: - Delegate Piker view

extension AddViewController: LabelTextfieldViewDelegate {
    func pushToPiker(type: LabelTextfieldViewType) {
    switch type {
            
        case .quantity:
            let addPersonsPikerViewController = AddPersonsPikerViewController()
            addPersonsPikerViewController.delegate = self
            addPersonsPikerViewController.modalTransitionStyle = .crossDissolve
            addPersonsPikerViewController.modalPresentationStyle = .fullScreen
            UIView.animate(withDuration: 0.4, delay: 0.2, options: [.repeat]) {
                self.present(addPersonsPikerViewController, animated: true)
            }
        case .cookingTime:
            let addDatePikerViewController = AddDatePikerViewController()
            addDatePikerViewController.delegate = self
            addDatePikerViewController.modalTransitionStyle = .crossDissolve
            addDatePikerViewController.modalPresentationStyle = .fullScreen
            UIView.animate(withDuration: 0.4, delay: 0.2, options: [.repeat]) {
                self.present(addDatePikerViewController, animated: true)
            }
        case .category:
           let addCategoryViewController = AddCategoryViewController()
        addCategoryViewController.delegate = self
        addCategoryViewController.modalTransitionStyle = .crossDissolve
        addCategoryViewController.modalPresentationStyle = .pageSheet
        UIView.animate(withDuration: 0.4, delay: 0.2, options: [.repeat]) {
            self.present(addCategoryViewController, animated: true)
        }
        }
    }
}
extension AddViewController: AddDatePikerViewControllerDelegate {
    func getDataString(string: String) {
        DispatchQueue.main.async {[weak self] in
            self?.cookigTimeView.textField.text = string
        }
    }
}
extension AddViewController: AddPersonsPikerViewControllerDelegate {
    func toPushViewController(quantityPerson: String) {
        self.quantityView.textField.text = quantityPerson
    }
}
extension AddViewController: AddCategoryViewControllerDelegate {
    func puchToViewController(category: Categories) {
        self.categoryView.textField.text = category.title

    }
    
}

//MARK: - extention, ImagePiker
extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if isMainImage, let selectedImage = info[.originalImage] as? UIImage {
            bestImageView.image = selectedImage
            isMainImage = false
        } else if let selectedImage = info[.originalImage] as? UIImage  {
            if let index = index {
                
                viewModel.instructions[index].updateImage(image: selectedImage)
                cookingTableView.reloadData()
            } else {
                let newIngredient = CookingTableViewCellViewModel(instruction: "", image: selectedImage)
                viewModel.instructions.append(newIngredient)
                cookingTableView.reloadData()
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
//MARK: - Delegate cell


extension AddViewController: AddIngredientTableViewCellDelegate {
    func updateData(ingredient: String, viewModel: AddIngredientTableViewCellViewModel) {
        if let index = self.viewModel.ingregients.firstIndex(where: { $0.id == viewModel.id }) {
            self.viewModel.ingregients[index] = viewModel
           } else {
               self.viewModel.ingregients.append(viewModel)
           }
    }
}

extension AddViewController: CookingTableViewCellDelegate {
    func updateData(instruction: String, viewModel: CookingTableViewCellViewModel) {
        if let index = self.viewModel.instructions.firstIndex(where: { $0.id == viewModel.id }) {
            self.viewModel.instructions[index] = viewModel
           } else {
               self.viewModel.instructions.append(viewModel)
           }
    }
    
    func didTappedImage(cell: CookingTableViewCell) {
        self.index = viewModel.getIndex(cell: cell) 
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
}

//MARK: - extension TopHeader

extension AddViewController: TopBarViewDelegate {
   
    
    func saveRecipe() {
        //TODO: - verification and make to save
        guard let title = titleRecipeTeactsField.text,  !title.isEmpty, let description = descriptionTextView.text, !description.isEmpty,
              let category = categoryView.textField.text, !category.isEmpty, let quantity = quantityView.textField.text, !quantity.isEmpty,
              let time = cookigTimeView.textField.text, !time.isEmpty else { return }

        let ingredients: [Ingredient] = viewModel.ingregients.map { viewModel in
            return Ingredient(title: viewModel.ingredient)
        }
        let steps: [Step] = viewModel.instructions.map { viewModel in
            return Step(title: viewModel.instruction, imageUrl: viewModel.imageUrlString)
        }
        viewModel.getUsername()
        guard let username = viewModel.username else { return }
        
        viewModel.addToFirebase(mainImage: bestImageView.image, title: title, description: description, category: category, quantity: quantity, time: time, ingredient: ingredients , step: steps, username: username) {[weak self] in
            self?.dismiss(animated: true)
        }
        dismiss(animated: true)

    }
    func closeView() {
        dismiss(animated: true)
    }
}




