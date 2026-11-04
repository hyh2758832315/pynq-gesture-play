ACCENT = "#e8377e"
ACCENT_HOVER = "#f26199"
ACCENT_TEXT = "#201018"
TEXT = "#f4f7f8"


STUDIO_STYLESHEET = """
QWidget {
    color: #f4f7f8;
    font-family: "Bahnschrift", "Microsoft YaHei UI", "Noto Sans CJK SC";
    font-size: 10pt;
}
QMainWindow, QWidget#studioRoot, QStackedWidget, QWidget#gamePreviewPage, QScrollArea#gamePreviewScroll {
    background: #18151a;
}
QDialog, QMenu {
    background: #241b23;
}
QMenu::item:selected {
    background: #e8377e;
    color: #201018;
}
QLabel {
    background: transparent;
}
QFrame#topBar, QFrame#statusBar, QFrame#navigationRail, QFrame#commandBar {
    background: #241b23;
    border: 0;
}
QFrame#topBar {
    border-bottom: 1px solid #765568;
}
QFrame#statusBar {
    border-top: 1px solid #45323f;
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
    color: #f58bb5;
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
    background: #302630;
    border: 1px solid #604454;
    border-radius: 4px;
    padding: 7px 12px;
}
QPushButton:hover, QToolButton:hover {
    background: #3c2c38;
    border-color: #8c657a;
}
QPushButton:pressed, QToolButton:pressed, QToolButton:checked {
    background: #e8377e;
    border-color: #e8377e;
    color: #201018;
}
QPushButton:focus, QToolButton:focus {
    border-color: #e8377e;
}
QPushButton#primaryAction {
    background: #e8377e;
    border-color: #e8377e;
    color: #201018;
    font-weight: 700;
}
QPushButton#primaryAction:hover {
    background: #f26199;
}
QPushButton#primaryAction:pressed, QPushButton#deviceButton:pressed {
    background: #e8377e;
    border-color: #e8377e;
    color: #201018;
}
QPushButton:disabled, QToolButton:disabled,
QPushButton#primaryAction:disabled, QPushButton#deviceButton:disabled {
    background: #272128;
    border-color: #4f3b49;
    color: #aeb8bd;
}
QPushButton#deviceButton {
    background: #30232d;
    border-color: #765568;
}
QToolButton {
    padding: 4px;
}
QListWidget, QTreeWidget {
    background: #141116;
    border: 1px solid #604454;
    selection-background-color: #452b3a;
    selection-color: #f4f7f8;
}
QListWidget#workspaceNavigation {
    background: #241b23;
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
    background: #3d2533;
    border-left-color: #e8377e;
    color: #ffffff;
}
QListWidget#gameLibrary {
    background: #141116;
    border: 1px solid #45323f;
    outline: 0;
}
QListWidget#gameLibrary::item {
    border-left: 3px solid transparent;
    color: #e8ecef;
    min-height: 42px;
    padding: 5px 8px;
}
QListWidget#gameLibrary::item:selected {
    background: #3d2533;
    border-left-color: #e8377e;
    color: #ffffff;
}
QTreeWidget#projectFileTree, QPlainTextEdit#sourceEditor, QTabWidget#gameViewTabs::pane,
QTabWidget#gameInspector::pane {
    background: #141116;
    border: 1px solid #45323f;
}
QTreeWidget#projectFileTree::item:selected {
    background: #452b3a;
    color: #ffffff;
}
QPlainTextEdit#sourceEditor {
    color: #dfe7eb;
    font-family: "Cascadia Code";
    font-size: 12px;
    selection-background-color: #683b52;
}
QTabBar::tab {
    background: #261e27;
    border: 1px solid #45323f;
    padding: 7px 12px;
}
QTabBar::tab:selected {
    background: #452b3a;
    border-bottom-color: #e8377e;
}
QTabWidget::pane {
    border: 1px solid #45323f;
}
QComboBox, QLineEdit, QSpinBox, QDoubleSpinBox {
    background: #141116;
    border: 1px solid #8c657a;
    border-radius: 3px;
    color: #f4f7f8;
    padding: 6px 8px;
}
QComboBox:hover, QComboBox:focus,
QLineEdit:focus, QSpinBox:focus, QDoubleSpinBox:focus {
    border-color: #e8377e;
}
QComboBox:disabled, QLineEdit:disabled,
QSpinBox:disabled, QDoubleSpinBox:disabled {
    background: #171b1d;
    border-color: #4f3b49;
    color: #aeb8bd;
}
QComboBox {
    padding-right: 30px;
}
QComboBox::drop-down {
    border-left: 1px solid #8c657a;
    width: 24px;
}
QComboBox QAbstractItemView {
    background: #1c171e;
    border: 1px solid #8c657a;
    color: #f4f7f8;
    outline: 0;
    padding: 4px;
    selection-background-color: #e8377e;
    selection-color: #201018;
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
    background: #452b3a;
    color: #ffffff;
}
QFrame#workspacePanel, QFrame#inspectorPanel, QFrame#viewportPanel {
    background: #272128;
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
    background: #3d2533;
    border: 0;
    border-radius: 3px;
    height: 6px;
    text-align: center;
}
QProgressBar::chunk {
    background: #e8377e;
    border-radius: 3px;
}
QListWidget#contentLoadList::indicator {
    width: 16px;
    height: 16px;
    border: 1px solid #aeb8bd;
    background: #272128;
}
QListWidget#contentLoadList::indicator:checked {
    background: #e8377e;
    border: 2px solid #f4f7f8;
}
QPlainTextEdit#sessionLog {
    background: #0b0d0e;
    border: 0;
    color: #aeb8bd;
    font-family: "Cascadia Code";
    font-size: 11px;
    padding: 6px;
}
QPlainTextEdit#visionResultDetails {
    background: #1c171e;
    border: 1px solid #604454;
    color: #f4f7f8;
    font-family: "Microsoft YaHei UI", "Noto Sans CJK SC";
    font-size: 10pt;
    padding: 6px;
    selection-background-color: #683b52;
}
QTableWidget {
    background: #1c171e;
    alternate-background-color: #261e27;
    border: 1px solid #45323f;
    gridline-color: #45323f;
    selection-background-color: #583448;
}
QHeaderView::section {
    background: #332630;
    color: #b8c1c6;
    border: 0;
    border-right: 1px solid #4f3b49;
    padding: 8px;
}
QTableCornerButton::section {
    background: #302630;
    border: 0;
}
QSlider::groove:horizontal {
    height: 4px;
    background: #604454;
}
QSlider::handle:horizontal {
    width: 12px;
    margin: -4px 0;
    background: #e8377e;
    border-radius: 3px;
}
QSlider::handle:horizontal:disabled {
    background: #aeb8bd;
}
QSplitter::handle {
    background: #604454;
}
QScrollArea {
    border: 0;
    background: transparent;
}
QToolTip {
    background: #302630;
    color: #f4f7f8;
    border: 1px solid #8c657a;
    padding: 6px;
}
QScrollBar:vertical {
    background: #111315;
    width: 10px;
}
QScrollBar::handle:vertical {
    background: #765568;
    min-height: 24px;
    border-radius: 4px;
}
"""
