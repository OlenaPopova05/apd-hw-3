import SnapKit
import UIKit

final class StudentDetailsViewController: UIViewController {
    private let store: StudentStore
    private let studentID: UUID
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    init(store: StudentStore, studentID: UUID) {
        self.store = store
        self.studentID = studentID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        scrollView.accessibilityIdentifier = "studentDetails"
        contentStack.axis = .vertical
        contentStack.spacing = 12

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentStack.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide).inset(16)
            make.width.equalTo(scrollView.frameLayoutGuide).offset(-32)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showStudent()
    }

    private func showStudent() {
        contentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        guard let student = store.students.first(where: { $0.id == studentID }) else {
            title = "Student"
            navigationItem.rightBarButtonItem = nil
            contentStack.addArrangedSubview(makeLabel("Student not found"))
            return
        }

        title = student.name
        let editButton = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(editStudent)
        )
        editButton.accessibilityIdentifier = "editStudentButton"
        navigationItem.rightBarButtonItem = editButton
        addAvatar(for: student)

        let fields = [
            "ID: \(student.id.uuidString)",
            "Name: \(student.name)",
            "Age: \(student.age)",
            "Average grade: \(student.averageGrade)",
            "Scholarship: \(student.isScholarshipHolder ? "Yes" : "No")"
        ]
        fields.forEach { contentStack.addArrangedSubview(makeLabel($0)) }

        contentStack.addArrangedSubview(makeLabel("Subjects:"))
        if student.subjects.isEmpty {
            contentStack.addArrangedSubview(makeLabel("None"))
        } else {
            student.subjects.forEach(addSubjectButton)
        }

        contentStack.addArrangedSubview(makeLabel("Avatar asset: \(student.avatarName)"))
    }

    @objc private func editStudent() {
        let form = StudentFormViewController(store: store, mode: .edit(studentID))
        navigationController?.pushViewController(form, animated: true)
    }

    private func addSubjectButton(_ subject: String) {
        let button = UIButton(type: .system)
        button.setTitle(subject, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.titleLabel?.numberOfLines = 0
        button.contentHorizontalAlignment = .leading
        button.accessibilityIdentifier = "subjectButton.\(subject)"
        button.accessibilityLabel = "Show students studying \(subject)"
        button.addTarget(self, action: #selector(openSubject(_:)), for: .touchUpInside)
        contentStack.addArrangedSubview(button)
        button.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(30)
        }
    }

    @objc private func openSubject(_ sender: UIButton) {
        guard let subject = sender.currentTitle else { return }
        let filteredList = StudentsViewController(store: store, subject: subject)
        navigationController?.pushViewController(filteredList, animated: true)
    }

    private func addAvatar(for student: Student) {
        let avatarSize: CGFloat = 112
        let container = UIView()
        let imageView = UIImageView(
            image: UIImage(named: student.avatarName) ?? UIImage(named: "avatar-default")
        )
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = avatarSize / 2
        imageView.isAccessibilityElement = false

        contentStack.addArrangedSubview(container)
        container.addSubview(imageView)
        container.snp.makeConstraints { make in
            make.height.equalTo(avatarSize)
        }
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: avatarSize, height: avatarSize))
        }
    }

    private func makeLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }
}
