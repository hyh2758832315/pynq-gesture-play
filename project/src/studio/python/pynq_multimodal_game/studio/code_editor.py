from __future__ import annotations

from pathlib import Path

from PySide6.QtCore import QRegularExpression, Qt, Signal
from PySide6.QtGui import QColor, QFont, QSyntaxHighlighter, QTextCharFormat
from PySide6.QtWidgets import (
    QHBoxLayout,
    QPlainTextEdit,
    QPushButton,
    QSplitter,
    QTabWidget,
    QTreeWidget,
    QTreeWidgetItem,
    QVBoxLayout,
    QWidget,
)


class PythonHighlighter(QSyntaxHighlighter):
    def __init__(self, document) -> None:  # type: ignore[no-untyped-def]
        super().__init__(document)
        keyword = QTextCharFormat()
        keyword.setForeground(QColor("#55d6be"))
        keyword.setFontWeight(QFont.Weight.Bold)
        string = QTextCharFormat()
        string.setForeground(QColor("#f0b35a"))
        number = QTextCharFormat()
        number.setForeground(QColor("#79b8ff"))
        comment = QTextCharFormat()
        comment.setForeground(QColor("#76848c"))
        self._rules = [
            (
                QRegularExpression(
                    r"\b(?:and|as|assert|async|await|break|class|continue|def|del|elif|else|except|False|finally|for|from|global|if|import|in|is|lambda|None|nonlocal|not|or|pass|raise|return|True|try|while|with|yield)\b"
                ),
                keyword,
            ),
            (QRegularExpression(r"\b(?:0[xX][0-9a-fA-F]+|\d+(?:\.\d+)?)\b"), number),
            (QRegularExpression(r"(?:\"[^\"]*\"|'[^']*')"), string),
            (QRegularExpression(r"#[^\n]*"), comment),
        ]

    def highlightBlock(self, text: str) -> None:
        for expression, text_format in self._rules:
            iterator = expression.globalMatch(text)
            while iterator.hasNext():
                match = iterator.next()
                self.setFormat(match.capturedStart(), match.capturedLength(), text_format)


class ProjectCodeEditor(QWidget):
    dirty_changed = Signal(bool)
    file_saved = Signal(str)
    save_failed = Signal(str)

    def __init__(self) -> None:
        super().__init__()
        self.project_root: Path | None = None
        self._editors: dict[Path, QPlainTextEdit] = {}
        self._dirty: set[Path] = set()
        self._read_only_files: set[Path] = set()

        root = QVBoxLayout(self)
        root.setContentsMargins(0, 0, 0, 0)
        root.setSpacing(8)
        actions = QHBoxLayout()
        actions.addStretch()
        self.save_button = QPushButton("保存全部")
        self.save_button.setEnabled(False)
        self.save_button.clicked.connect(self._save_requested)
        actions.addWidget(self.save_button)
        root.addLayout(actions)

        splitter = QSplitter(Qt.Orientation.Horizontal)
        self.file_tree = QTreeWidget()
        self.file_tree.setObjectName("projectFileTree")
        self.file_tree.setHeaderHidden(True)
        self.file_tree.setMinimumWidth(190)
        self.file_tree.itemClicked.connect(self._open_tree_item)
        self.file_tree.itemDoubleClicked.connect(self._open_tree_item)
        splitter.addWidget(self.file_tree)
        self.tabs = QTabWidget()
        self.tabs.setTabsClosable(True)
        self.tabs.tabCloseRequested.connect(self._close_tab)
        splitter.addWidget(self.tabs)
        splitter.setStretchFactor(1, 1)
        root.addWidget(splitter, 1)

    @property
    def dirty(self) -> bool:
        return bool(self._dirty)

    def open_project(self, root: Path) -> None:
        self.close_project()
        self.project_root = Path(root).resolve()
        root_item = QTreeWidgetItem([self.project_root.name])
        self.file_tree.addTopLevelItem(root_item)
        for path in self._project_files():
            relative = path.relative_to(self.project_root)
            item = QTreeWidgetItem([relative.as_posix()])
            item.setData(0, Qt.ItemDataRole.UserRole, str(path))
            root_item.addChild(item)
        root_item.setExpanded(True)
        dependency_item = QTreeWidgetItem(["平台 API（只读）"])
        self.file_tree.addTopLevelItem(dependency_item)
        package_root = Path(__file__).resolve().parents[1]
        for name in ("game_sdk.py", "scene.py", "engine/side_scroller.py"):
            path = (package_root / name).resolve()
            if path.is_file():
                self._read_only_files.add(path)
                item = QTreeWidgetItem([name])
                item.setData(0, Qt.ItemDataRole.UserRole, str(path))
                dependency_item.addChild(item)
        dependency_item.setExpanded(True)
        main = self.project_root / "src" / "main.py"
        if main.is_file():
            self.open_file(main)

    def close_project(self) -> None:
        self.save_all()
        self.tabs.clear()
        self.file_tree.clear()
        self._editors.clear()
        self._dirty.clear()
        self._read_only_files.clear()
        self.project_root = None
        self._update_dirty_state()

    def open_file(self, path: Path) -> None:
        path = Path(path).resolve()
        if self.project_root is None or (
            not path.is_relative_to(self.project_root) and path not in self._read_only_files
        ):
            raise ValueError("source file is outside the active project")
        editor = self._editors.get(path)
        if editor is not None:
            self.tabs.setCurrentWidget(editor)
            return
        editor = QPlainTextEdit()
        editor.setObjectName("sourceEditor")
        editor.setLineWrapMode(QPlainTextEdit.LineWrapMode.NoWrap)
        editor.setPlainText(path.read_text(encoding="utf-8"))
        editor.document().setModified(False)
        read_only = path in self._read_only_files
        editor.setReadOnly(read_only)
        if path.suffix == ".py":
            PythonHighlighter(editor.document())
        if not read_only:
            editor.textChanged.connect(lambda current=path: self._mark_dirty(current))
        self._editors[path] = editor
        self.tabs.addTab(editor, path.name + (" [只读]" if read_only else ""))
        self.tabs.setCurrentWidget(editor)

    def save_all(self) -> None:
        for path in tuple(self._dirty):
            editor = self._editors[path]
            path.write_text(editor.toPlainText(), encoding="utf-8")
            editor.document().setModified(False)
            self._dirty.remove(path)
            self.file_saved.emit(str(path))
            self._set_tab_title(path)
        self._update_dirty_state()

    def _project_files(self) -> tuple[Path, ...]:
        assert self.project_root is not None
        files = [self.project_root / "game.toml"]
        files.extend(sorted((self.project_root / "src").rglob("*.py")))
        return tuple(path for path in files if path.is_file())

    def _open_tree_item(self, item: QTreeWidgetItem, _column: int = 0) -> None:
        value = item.data(0, Qt.ItemDataRole.UserRole)
        if value:
            self.open_file(Path(value))

    def _mark_dirty(self, path: Path) -> None:
        editor = self._editors.get(path)
        if editor is None:
            return
        if editor.document().isModified():
            self._dirty.add(path)
        else:
            self._dirty.discard(path)
        self._set_tab_title(path)
        self._update_dirty_state()

    def _set_tab_title(self, path: Path) -> None:
        editor = self._editors[path]
        index = self.tabs.indexOf(editor)
        if index >= 0:
            suffix = " *" if path in self._dirty else ""
            self.tabs.setTabText(index, path.name + suffix)

    def _close_tab(self, index: int) -> None:
        try:
            self.save_all()
        except OSError as error:
            self.save_failed.emit(str(error))
            return
        editor = self.tabs.widget(index)
        path = next((key for key, value in self._editors.items() if value is editor), None)
        if path is not None:
            self._editors.pop(path)
            self._dirty.discard(path)
        self.tabs.removeTab(index)
        self._update_dirty_state()

    def _save_requested(self) -> None:
        try:
            self.save_all()
        except OSError as error:
            self.save_button.setToolTip(f"保存失败，编辑内容已保留：{error}")
            self.save_failed.emit(str(error))

    def _update_dirty_state(self) -> None:
        dirty = bool(self._dirty)
        self.save_button.setEnabled(dirty)
        self.dirty_changed.emit(dirty)
