import UIKit
import zh_native_channel

final class NativeDemoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "原生ViewController"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(close)
        )

        let buttons = UIStackView(arrangedSubviews: [
            makeDemoButton(title: "打开 Flutter 页面", action: #selector(openFlutterPage)),
            makeDemoButton(title: "向 Flutter 获取数据", action: #selector(requestFlutterData))
        ])
        buttons.axis = .vertical
        buttons.spacing = 12
        buttons.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttons)

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            buttons.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 24),
            buttons.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            buttons.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24)
        ])
    }

    private func makeDemoButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: action, for: .touchUpInside)
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        return button
    }

    @objc private func close() {
        dismiss(animated: true)
    }

    @objc private func openFlutterPage() {
        present(FlutterWidgetVC(route: "/native_use_flutter_page"), animated: true)
    }

    @objc private func requestFlutterData() {
        MethodChannelMsgManager.shared.invoke(GETFlutterDataMsg(data: "")) { [weak self] result in
            let message: String
            switch result {
            case .success(let value):
                message = (value as? GETFlutterDataMsg)?.data ?? "返回的数据格式不正确"
            case .failure(let error):
                message = error.localizedDescription
            }

            DispatchQueue.main.async {
                guard let self, self.viewIfLoaded?.window != nil,
                      self.presentedViewController == nil else { return }
                let alert = UIAlertController(title: "Flutter 响应", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "关闭", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
}
