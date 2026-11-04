STUDIO_STYLESHEET = """
QWidget {
    color: #f4f7f8;
    font-family: "Bahnschrift", "Microsoft YaHei UI", "Noto Sans CJK SC";
    font-size: 10pt;
}
QMainWindow, QWidget#studioRoot, QStackedWidget, QWidget#gamePreviewPage, QScrollArea#gamePreviewScroll {
    background: #151719;
}
QDialog, QMenu {
    background: #1b1e21;
}
QMenu::item:selected {
    background: #38c7c9;
    color: #071012;
}
QLabel {
    background: transparent;
}
QFrame#topBar, QFrame#statusBar, QFrame#navigationRail, QFrame#commandBar {
    background: #1b1e21;
    border: 0;
}
QFrame#topBar {
    border-bottom: 1px solid #2a3033;
}
QFrame#statusBar {
    border-top: 1px solid #2a3033;
}
QLabel#brandLabel {
    color: #ffffff;
    font-family: "Cascadia Code";
    font-size: 17px;
    font-weight: 700;
}
QLabel#sectionLabel {
    color: #ffffff;
    font-size: 18px;
    font-weight: 700;
}
QLabel#eyebrowLabel {
    color: #38c7c9;
    font-family: "Cascadia Code";
    font-size: 11px;
    font-weight: 700;
}
QLabel#mutedLabel, QLabel#metricName {
    color: #aeb8bd;
}
QLabel#metricValue {
    color: #ffffff;
    font-family: "Cascadia Code";
    font-size: 14px;
    font-weight: 700;
}
QLabel#deviceReady, QLabel#resultPass, QLabel[status="success"] {
    color: #9edb9a;
    font-weight: 700;
}
QLabel#deviceOffline, QLabel[status="muted"] {
    color: #aeb8bd;
}
QLabel#deviceWaiting, QLabel[status="waiting"] {
    color: #efc078;
    font-weight: 700;
}
QLabel#deviceError, QLabel#resultFail, QLabel[status="error"] {
    color: #ff9687;
    font-weight: 700;
}
QPushButton, QToolButton {
    background: #252a2e;
    border: 1px solid #3b4248;
    border-radius: 4px;
    padding: 7px 12px;
}
QPushButton:hover, QToolButton:hover {
    background: #2b3236;
    border-color: #59666d;
}
QPushButton:pressed, QToolButton:pressed, QToolButton:checked {
    background: #38c7c9;
    border-color: #38c7c9;
    color: #071012;
}
QPushButton:focus, QToolButton:focus {
    border-color: #38c7c9;
}
QPushButton#primaryAction {
    background: #38c7c9;
    border-color: #38c7c9;
    color: #071012;
    font-weight: 700;
}
QPushButton#primaryAction:hover {
    background: #68d7d8;
}
QPushButton#primaryAction:pressed, QPushButton#deviceButton:pressed {
    background: #38c7c9;
    border-color: #38c7c9;
    color: #071012;
}
QPushButton:disabled, QToolButton:disabled,
QPushButton#primaryAction:disabled, QPushButton#deviceButton:disabled {
    background: #202428;
    border-color: #343c40;
    color: #aeb8bd;
}
QPushButton#deviceButton {
    background: #1b2022;
    border-color: #465158;
}
QToolButton {
    padding: 4px;
}
QListWidget, QTreeWidget {
    background: #101315;
    border: 1px solid #3b4248;
    selection-background-color: #2b3539;
    selection-color: #f4f7f8;
}
QListWidget#workspaceNavigation {
    background: #1b1e21;
    border: 0;
    outline: 0;
    padding: 8px 6px;
}
QListWidget#workspaceNavigation::item {
    border-left: 1px solid transparent;
    color: #aeb8bd;
    min-height: 38px;
    padding: 5px 8px;
}
QListWidget#workspaceNavigation::item:selected {
    background: #24292c;
    border-left-color: #38c7c9;
    color: #ffffff;
}
QListWidget#gameLibrary {
    background: #101315;
    border: 1px solid #2a3033;
    outline: 0;
}
QListWidget#gameLibrary::item {
    border-left: 3px solid transparent;
    color: #e8ecef;
    min-height: 42px;
    padding: 5px 8px;
}
QListWidget#gameLibrary::item:selected {
    background: #24292c;
    border-left-color: #38c7c9;
    color: #ffffff;
}
QTreeWidget#projectFileTree, QPlainTextEdit#sourceEditor, QTabWidget#gameViewTabs::pane,
QTabWidget#gameInspector::pane {
    background: #101315;
    border: 1px solid #2a3033;
}
QTreeWidget#projectFileTree::item:selected {
    background: #2b3539;
    color: #ffffff;
}
QPlainTextEdit#sourceEditor {
    color: #dfe7eb;
    font-family: "Cascadia Code";
    font-size: 12px;
    selection-background-color: #35515a;
}
QTabBar::tab {
    background: #1a1f21;
    border: 1px solid #2a3033;
    padding: 7px 12px;
}
QTabBar::tab:selected {
    background: #293136;
    border-bottom-color: #38c7c9;
}
QTabWidget::pane {
    border: 1px solid #2a3033;
}
QComboBox, QLineEdit, QSpinBox, QDoubleSpinBox {
    background: #101315;
    border: 1px solid #59666d;
    border-radius: 3px;
    color: #f4f7f8;
    padding: 6px 8px;
}
QComboBox:hover, QComboBox:focus,
QLineEdit:focus, QSpinBox:focus, QDoubleSpinBox:focus {
    border-color: #38c7c9;
}
QComboBox:disabled, QLineEdit:disabled,
QSpinBox:disabled, QDoubleSpinBox:disabled {
    background: #171b1d;
    border-color: #343c40;
    color: #aeb8bd;
}
QComboBox {
    padding-right: 30px;
}
QComboBox::drop-down {
    border-left: 1px solid #59666d;
    width: 24px;
}
QComboBox QAbstractItemView {
    background: #15191b;
    border: 1px solid #59666d;
    color: #f4f7f8;
    outline: 0;
    padding: 4px;
    selection-background-color: #38c7c9;
    selection-color: #071012;
}
QComboBox QAbstractItemView::item {
    min-height: 28px;
    padding: 4px 8px;
}
QListWidget#testCaseList::item {
    color: #e8ecef;
    min-height: 34px;
    padding: 4px 7px;
}
QListWidget#testCaseList::item:selected {
    background: #2b3539;
    color: #ffffff;
}
QFrame#workspacePanel, QFrame#inspectorPanel, QFrame#viewportPanel {
    background: #202428;
    border: 0;
    border-radius: 0;
}
QLabel#emptyCanvas {
    background: #0b0d0e;
    border: 1px dashed #3a4449;
    color: #aeb8bd;
    font-family: "Cascadia Code";
    font-size: 15px;
}
QLabel#gameViewport {
    background: #090a0b;
    border: 1px solid #333b3f;
}
QProgressBar {
    background: #24292c;
    border: 0;
    border-radius: 3px;
    height: 6px;
    text-align: center;
}
QProgressBar::chunk {
    background: #38c7c9;
    border-radius: 3px;
}
QPlainTextEdit#sessionLog {
    background: #0b0d0e;
    border: 0;
    color: #aeb8bd;
    font-family: "Cascadia Code";
    font-size: 11px;
    padding: 6px;
}
QTableWidget {
    background: #15191b;
    alternate-background-color: #1a1f21;
    border: 1px solid #2a3033;
    gridline-color: #2a3033;
    selection-background-color: #344046;
}
QHeaderView::section {
    background: #22272a;
    color: #b8c1c6;
    border: 0;
    border-right: 1px solid #343c40;
    padding: 8px;
}
QTableCornerButton::section {
    background: #252a2e;
    border: 0;
}
QSlider::groove:horizontal {
    height: 4px;
    background: #3b4248;
}
QSlider::handle:horizontal {
    width: 12px;
    margin: -4px 0;
    background: #38c7c9;
    border-radius: 3px;
}
QSlider::handle:horizontal:disabled {
    background: #aeb8bd;
}
QSplitter::handle {
    background: #3b4248;
}
QScrollArea {
    border: 0;
    background: transparent;
}
QToolTip {
    background: #252a2e;
    color: #f4f7f8;
    border: 1px solid #59666d;
    padding: 6px;
}
QScrollBar:vertical {
    background: #111315;
    width: 10px;
}
QScrollBar::handle:vertical {
    background: #424b50;
    min-height: 24px;
    border-radius: 4px;
}
"""