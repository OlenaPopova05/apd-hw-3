import SnapKit
import UIKit

final class StudentTableViewCell: UITableViewCell {
    static let reuseIdentifier = "StudentTableViewCell"

    private let avatarView = UIImageView()
    private let nameLabel = UILabel()
    private let ageLabel = UILabel()
    private let gradeLabel = UILabel()
    private let scholarshipLabel = UILabel()
    private let textStack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }

    func configure(with student: Student) {
        avatarView.image = UIImage(named: student.avatarName) ?? UIImage(named: "avatar-default")
        nameLabel.text = student.name
        ageLabel.text = "Age: \(student.age)"
        gradeLabel.text = "Average grade: \(student.averageGrade)"
        scholarshipLabel.text = student.isScholarshipHolder
            ? "Scholarship: Yes"
            : "Scholarship: No"

        accessibilityIdentifier = "studentCell.\(student.id.uuidString)"
        accessibilityLabel = [
            student.name,
            ageLabel.text,
            gradeLabel.text,
            scholarshipLabel.text
        ].compactMap { $0 }.joined(separator: ", ")
    }

    private func setUpViews() {
        selectionStyle = .none
        isAccessibilityElement = true

        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 28
        avatarView.isAccessibilityElement = false

        nameLabel.font = .preferredFont(forTextStyle: .headline)
        nameLabel.adjustsFontForContentSizeCategory = true
        nameLabel.numberOfLines = 0

        for label in [ageLabel, gradeLabel, scholarshipLabel] {
            label.font = .preferredFont(forTextStyle: .subheadline)
            label.adjustsFontForContentSizeCategory = true
            label.textColor = .secondaryLabel
            label.numberOfLines = 0
        }

        textStack.axis = .vertical
        textStack.alignment = .fill
        textStack.spacing = 2
        [nameLabel, ageLabel, gradeLabel, scholarshipLabel].forEach {
            textStack.addArrangedSubview($0)
        }

        contentView.addSubview(avatarView)
        contentView.addSubview(textStack)

        avatarView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(12)
            make.size.equalTo(CGSize(width: 56, height: 56))
            make.bottom.lessThanOrEqualToSuperview().inset(12)
        }

        textStack.snp.makeConstraints { make in
            make.leading.equalTo(avatarView.snp.trailing).offset(12)
            make.top.bottom.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(16)
        }
    }
}
