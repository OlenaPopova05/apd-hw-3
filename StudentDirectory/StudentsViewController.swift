import SnapKit
import UIKit

final class StudentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let store: StudentStore
    private let subject: String?
    private let tableView = UITableView(frame: .zero, style: .plain)

    private var displayedStudents: [Student] {
        guard let subject else { return store.students }
        return store.students(matchingSubject: subject)
    }

    init(store: StudentStore, subject: String? = nil) {
        self.store = store
        self.subject = subject
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = subject ?? "Students"
        view.backgroundColor = .systemBackground

        tableView.accessibilityIdentifier = "studentList"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(
            StudentTableViewCell.self,
            forCellReuseIdentifier: StudentTableViewCell.reuseIdentifier
        )

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayedStudents.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StudentTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? StudentTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(with: displayedStudents[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let studentID = displayedStudents[indexPath.row].id
        let details = StudentDetailsViewController(store: store, studentID: studentID)
        navigationController?.pushViewController(details, animated: true)
    }
}
