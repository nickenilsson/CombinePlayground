//
//  ViewControllerViewModelImpl.swift
//  CombinePlayground
//
//  Created by niknil01 on 2023-03-24.
//

import Foundation
import Combine

final class ViewControllerViewModelImpl: ViewControllerViewModel {
    
    var title: AnyPublisher<String?, Never> = Just("Här kommer en titel från vymodellen").eraseToAnyPublisher()
    
    var buttonTitle: AnyPublisher<String?, Never> = Just("knapptitel från vymodellen").eraseToAnyPublisher()
    
    var buttonPressedSubject: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        Publishers.CombineLatest(buttonPressedSubject, title).sink { title in
            print("### buttonPressed. Title value: \(title)")
        }
        .store(in: &cancellables)
    }
    
}
