//
//  BottomSheetViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 1.07.2024.
//

import UIKit


class BottomSheetViewController: UIViewController {

    @IBOutlet var mainScreenContainer: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    private var data: [String]
    private var optionSelected: ((String) -> Void)
    private var selectedOption: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPicker()
    }
    
    init(
        data: [String],
        selectedOption: String?,
        optionSelected: @escaping ( (String) -> Void)
    ) {
        self.data = data
        self.selectedOption = selectedOption
        self.optionSelected = optionSelected
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        let selectedOption = data[selectedRow]
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.optionSelected(selectedOption)
        }
    }
}

private extension BottomSheetViewController {
    final func setupUI() {
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        pickerView.backgroundColor = .clear
        mainScreenContainer.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
    }
    
    final func setupPicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        guard let selectedOption,
              !selectedOption.isEmpty,
              let selectedRowIndex = data.firstIndex(where: {$0 == selectedOption }) else { return }
        pickerView.selectRow(selectedRowIndex, inComponent: 0, animated: false)
    }
}

extension BottomSheetViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        data.count
    }
}
    
extension BottomSheetViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        data[row]
    }
}
