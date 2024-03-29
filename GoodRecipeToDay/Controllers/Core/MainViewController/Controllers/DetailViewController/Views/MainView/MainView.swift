


import UIKit
import SDWebImage
import Cosmos

protocol MainViewDelegate: AnyObject {
    func presentInstruction(step:[Step], indexPath: IndexPath)
    func reloadChatView()
    func reloadVM()
    func changeSize()
    func showFollowView(title: String)
}

class MainView: UIView {
    // MARK: - Properties
 
    
    weak var delegate: MainViewDelegate?
    var viewModel: MainViewViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            userView.configure(isFollow: viewModel.isFallow, viewModel: UserViewViewModel(username: viewModel.username))
            rateView.rating = viewModel.rate
        }
    }
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    lazy var topGayView: TopGrayView = {
        let view = TopGrayView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "Info", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Chat", at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    let chatView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemBackground
        view.isHidden = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var contentView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var rateView: CosmosView = {
        let view = CosmosView()
        view.settings.filledColor = .systemYellow
        view.settings.emptyColor = .systemGray
        view.settings.totalStars = 5
        view.settings.starSize = 20
        // TODO: - get rate from server
        view.settings.starMargin = 3.3
        view.settings.fillMode = .precise
        view.didTouchCosmos = { [weak self] rating in
            let rateString = "You rate: \(rating.rounded(toDecimalPlaces: 1))"
            guard let strongSelf = self, let viewModel = strongSelf.viewModel else { return }
            viewModel.updateRecipeRate(rate: rating)
            view.text = rateString
            self?.delegate?.reloadVM()
            NotificationCenter.default.post(name: .didUpdateCoredata, object: nil, userInfo: nil)
        }
        view.settings.textColor = .systemGreen
        view.settings.textMargin = 14
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var userView: UserView = {
        let view = UserView(frame: .zero)
        view.delegate = self
        return view
    }()
    let timeView: TimeView = {
        let view = TimeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let descriptionView: DescriptionView = {
        let view = DescriptionView()
        return view
    }()
    let contentScrollView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var ingredientTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.register(IngredientTableViewCell.self, forCellReuseIdentifier: IngredientTableViewCell.identifier)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    lazy var instructionTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.register(InstructionTableViewCell.self, forCellReuseIdentifier: InstructionTableViewCell.identifair)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    var ingredientTableViewHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    var instructionTableViewHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var contentWidthConstraint: NSLayoutConstraint?
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView.delegate = self
        backgroundColor = .systemBackground
        instructionTableView.estimatedRowHeight = 100
        instructionTableView.rowHeight = UITableView.automaticDimension
        setupScrollView()
        setupContentView()
        contentView.addSubview(segmentedControl)
        contentView.addSubview(rateView)
        contentView.addSubview(title)
        contentView.addSubview(userView)
        contentView.addSubview(timeView)
        contentView.addSubview(descriptionView)
        contentView.addSubview(ingredientTableView)
        contentView.addSubview(instructionTableView)
        contentView.addSubview(chatView)
        contentView.addSubview(topGayView)
        addConstraints()
        calculateIngredientTableViewHeight()
        calculateInstructionTableViewHeight()
        ingredientTableView.delegate = self
        ingredientTableView.dataSource = self
        instructionTableView.delegate = self
        instructionTableView.dataSource = self
        ()
        UIView.performWithoutAnimation {
                  scrollView.setContentOffset(CGPoint(x: 0, y: 200), animated: false)
              }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    public func configure(recipe: Recipe) {
        self.viewModel = MainViewViewModel(recipe: recipe)
        guard let viewModel = viewModel else { return }
        viewModel.delegate = self
        DispatchQueue.main.async {[weak self] in
            self?.title.text = viewModel.title
            self?.descriptionView.descriptionsLabel.numberOfLines = 0
            self?.descriptionView.configure(description: viewModel.description)
            self?.userView.userLabel.text = viewModel.fromUser
            self?.timeView.configure(time: viewModel.time)
        }
        calculateIngredientTableViewHeight()
        calculateInstructionTableViewHeight()
    }
    public func changeFollow() {
        guard let viewModel = viewModel else { return }
        if viewModel.isFallow {
            viewModel.deleteFollowersFrolUser()
        } else  {
            viewModel.userToFollower()
        }
        userView.configure(isFollow: viewModel.isFallow, viewModel: UserViewViewModel(username: viewModel.username))
    }
    private func setupScrollView() {
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    private func setupContentView() {
        scrollView.addSubview(contentView)
        // Add constraints to contentView to enable scrolling
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        // Add a constraint to set the content width equal to the scrollView's width
        contentWidthConstraint = contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        contentWidthConstraint?.isActive = true
    }
    private func calculateIngredientTableViewHeight() {
        let totalRowHeight = CGFloat(viewModel?.ingredients.count ?? 0) * (50) + 70
        ingredientTableViewHeightConstraint.constant = totalRowHeight
    }
    private func calculateInstructionTableViewHeight() {
        let totalRowHeight = CGFloat(viewModel?.instruction.count ?? 0) * (50) + 70
        instructionTableViewHeightConstraint.constant = totalRowHeight
    }
    private func addConstraints() {
        let topGayViewConstraints = [
            topGayView.topAnchor.constraint(equalTo: topAnchor),
            topGayView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            topGayView.rightAnchor.constraint(equalTo: rightAnchor,constant: -20),
            topGayView.heightAnchor.constraint(equalToConstant: 20)
        ]
        NSLayoutConstraint.activate(topGayViewConstraints)
        let segmentedControlConstraints = [
            segmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            segmentedControl.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 40),
            segmentedControl.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -40),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(segmentedControlConstraints)
       let chatViewConstraints = [
        chatView.topAnchor.constraint(equalTo: topAnchor, constant: 80),
        chatView.leftAnchor.constraint(equalTo: leftAnchor),
        chatView.rightAnchor.constraint(equalTo: rightAnchor),
        chatView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(chatViewConstraints)
        let  rateViewConstraints = [
            rateView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),

            rateView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 40),
            rateView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -40)
        ]
        NSLayoutConstraint.activate(rateViewConstraints)
        let titleConstraints = [
            title.topAnchor.constraint(equalTo: rateView.bottomAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(titleConstraints)
        let userViewConstraints = [
            userView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            userView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            userView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            userView.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(userViewConstraints)
        let timeViewConstraints = [
            timeView.topAnchor.constraint(equalTo: userView.bottomAnchor, constant: 10),
            timeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            timeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            timeView.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(timeViewConstraints)
        let descriptionViewConstraints = [
            descriptionView.topAnchor.constraint(equalTo: timeView.bottomAnchor),
            descriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(descriptionViewConstraints)
        ingredientTableViewHeightConstraint = ingredientTableView.heightAnchor.constraint(equalToConstant: 0)
        let ingredientTableViewConstraints = [
            ingredientTableView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor),
            ingredientTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ingredientTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ingredientTableViewHeightConstraint        ]
        NSLayoutConstraint.activate(ingredientTableViewConstraints)
        instructionTableViewHeightConstraint = instructionTableView.heightAnchor.constraint(equalToConstant: 0)
       let instructionTableViewConstraints = [
            instructionTableView.topAnchor.constraint(equalTo: ingredientTableView.bottomAnchor),
            instructionTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            instructionTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            instructionTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            instructionTableViewHeightConstraint
        ]
        NSLayoutConstraint.activate(instructionTableViewConstraints)
    }


    @objc private func segmentedControlValueChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, delay: 1) {[weak self] in
                self?.chatView.isHidden = true
                self?.scrollView.isScrollEnabled = true
            }
        } else {
            UIView.animate(withDuration: 0.5, delay: 1) {[weak self] in
                self?.chatView.isHidden = false
                self?.scrollView.isScrollEnabled = false
                self?.delegate?.reloadChatView()

            }
        }
    }
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        delegate?.changeSize()
    }
}
extension MainView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ingredientTableView {
            return viewModel?.ingredients.count ?? 0
        } else {
            return viewModel?.instruction.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ingredientTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientTableViewCell.identifier, for: indexPath) as? IngredientTableViewCell else { return UITableViewCell() }
            guard let viewModel = viewModel else { return UITableViewCell() }
            let ingredients = viewModel.getIngredient(indexPath: indexPath)
            cell.configure(viewmodel: IngredientTableViewCellViewModel(ingredient: ingredients ))
            return cell
        } else if tableView == instructionTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InstructionTableViewCell.identifair,
                                                           for: indexPath) as?  InstructionTableViewCell
                                                            else { return UITableViewCell() }
            cell.delegate = self
            guard let viewModel = viewModel else { return UITableViewCell() }
            let instructionStep = viewModel.getInstruction(indexPath: indexPath)
            cell.configure(viewModel: InstructionTableViewCellViewModel(step: instructionStep, indexPath: indexPath))
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       if tableView == ingredientTableView {
            return 50
        } else  {
            return InstructionTableViewCell.height
        }
      }
     
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
         
         let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.frame.width - 30, height: 50))
         label.textColor = UIColor.label
         label.font = UIFont.boldSystemFont(ofSize: 18)
         if tableView == ingredientTableView{
             label.text = "Ingredients"
         } else {
             label.text = "Instruction"
             label.backgroundColor = .systemBackground
         }
         headerView.addSubview(label)
         return headerView
     }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


//MARK: - Delegate


extension MainView: InstructionTableViewCellDelegate {
    func showImage(viewModel: InstructionTableViewCellViewModel) {
        guard let mainViewModel = self.viewModel else { return }
            delegate?.presentInstruction(step: mainViewModel.instruction, indexPath: viewModel.indexPath)
    }
}
extension MainView: UserViewDelegate {
    func followerBottonPressed(title: String) {
        delegate?.showFollowView(title: title)
       
    }

    
}

extension MainView: MainViewViewModelDelegate {
    func changeIsFollow(viewModel: MainViewViewModel) {
        self.viewModel = viewModel
    }
}
