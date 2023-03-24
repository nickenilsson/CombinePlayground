//
//  ViewController.swift
//  CombinePlayground
//
//  Created by niknil01 on 2023-03-24.
//

import UIKit
import Combine

protocol ViewControllerViewModel {
    var title: AnyPublisher<String?, Never> { get }
    var buttonTitle: AnyPublisher<String?, Never> { get }
    var buttonPressedSubject: PassthroughSubject<Void, Never> { get }
}

class ViewController: UIViewController {
    
    private let viewModel: ViewControllerViewModel
    
    public init(viewModel: ViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(button)
        return stackView
    }()
    
    override func loadView() {
        view = UIView()
    }

    override func viewDidLoad() {
        view.backgroundColor = .cyan
        setupSubviews()
        super.viewDidLoad()
        
        bindToViewModel()
    }
    
    private func setupSubviews() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalToConstant: 100),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func bindToViewModel() {
        
        viewModel.title
            .receive(on: DispatchQueue.main)
            .sink { [weak self] title in
                self?.titleLabel.text = title
            }
            .store(in: &cancellables)
        
        viewModel.buttonTitle
            .receive(on: DispatchQueue.main)
            .sink { [weak self] buttonTitle in
                self?.button.setTitle(buttonTitle, for: .normal)
            }
            .store(in: &cancellables)
        
    }
    
    @objc
    private func buttonPressed() {
        viewModel.buttonPressedSubject.send(())
    }


}

