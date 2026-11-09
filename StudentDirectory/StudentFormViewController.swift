import SnapKit
import UIKit

final class StudentFormViewController: UIViewController {
    enum Mode {
        case add
        case edit(UUID)
    }

    private let store: StudentStore
    private let mode: Mode
    private let formStack = UIStackView()
    private let nameField = UITextField()
    private let ageField = UITextField()
    private let errorLabel = UILabel()

    init(store: StudentStore, mode: Mode) {
        self.store = store
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = formTitle

        let saveButton = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveStudent)
        )
        saveButton.accessibilityIdentifier = "saveStudentButton"
        navigationItem.rightBarButtonItem = saveButton

        formStack.axis = .vertical
        formStack.spacing = 12
        view.addSubview(formStack)
        formStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        configure(nameField, identifier: "studentNameField", placeholder: "Name")
        nameField.textContentType = .name
        nameField.autocapitalizationType = .words

        configure(ageField, identifier: "studentAgeField", placeholder: "Age")
        ageField.keyboardType = .numberPad

        formStack.addArrangedSubview(makeLabel("Name"))
        formStack.addArrangedSubview(nameField)
        formStack.addArrangedSubview(makeLabel("Age"))
        formStack.addArrangedSubview(ageField)

        errorLabel.textColor = .systemRed
        errorLabel.font = .preferredFont(forTextStyle: .body)
        errorLabel.adjustsFontForContentSizeCategory = true
        errorLabel.numberOfLines = 0
        errorLabel.accessibilityIdentifier = "studentFormError"
        errorLabel.isHidden = true
        formStack.addArrangedSubview(errorLabel)

        if case let .edit(id) = mode,
           let student = store.students.first(where: { $0.id == id }) {
            nameField.text = student.name
            ageField.text = String(student.age)
        }
    }

    private var formTitle: String {
        switch mode {
        case .add: "Add Student"
        case .edit: "Edit Student"
        }
    }

    private func configure(_ field: UITextField, identifier: String, placeholder: String) {
        field.borderStyle = .roundedRect
        field.placeholder = placeholder
        field.font = .preferredFont(forTextStyle: .body)
        field.adjustsFontForContentSizeCategory = true
        field.accessibilityIdentifier = identifier
        field.accessibilityLabel = placeholder
        field.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(44)
        }
    }

    private func makeLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }

    @objc private func saveStudent() {
        let name = nameField.text ?? ""
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showError("Name cannot be blank.")
            return
        }

        let ageText = ageField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard let age = Int(ageText) else {
            showError("Enter a valid age.")
            return
        }

        do {
            switch mode {
            case .add:
                try store.addStudent(name: name, age: age)
            case let .edit(id):
                try store.updateStudent(id: id, name: name, age: age)
            }
            navigationController?.popViewController(animated: true)
        } catch StudentStoreError.blankName {
            showError("Name cannot be blank.")
        } catch StudentStoreError.nonPositiveAge {
            showError("Age must be greater than zero.")
        } catch StudentStoreError.unknownID {
            showError("Student not found.")
        } catch {
            showError("Could not save the student.")
        }
    }

    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}
