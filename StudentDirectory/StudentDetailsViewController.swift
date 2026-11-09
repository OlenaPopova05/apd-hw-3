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

        guard let student = store.students.first(where: { $0.id == studentID }) else {
            title = "Student"
            contentStack.addArrangedSubview(makeLabel("Student not found"))
            return
        }

        title = student.name
        addAvatar(for: student)

        let fields = [
            "ID: \(student.id.uuidString)",
            "Name: \(student.name)",
            "Age: \(student.age)",
            "Average grade: \(student.averageGrade)",
            "Scholarship: \(student.isScholarshipHolder ? "Yes" : "No")",
            "Subjects: \(student.subjects.joined(separator: ", "))",
            "Avatar asset: \(student.avatarName)"
        ]
        fields.forEach { contentStack.addArrangedSubview(makeLabel($0)) }
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
