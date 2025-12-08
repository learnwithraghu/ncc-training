# Module 3: Text Editors - Vim (15 Minutes)

## Goal
Learn the basics of `vim`, a powerful command-line text editor.

## 1. Why Vim?
*   Available on almost every Linux system.
*   Very fast once you know the shortcuts.
*   Runs entirely in the terminal.

## 2. Modes
Vim has two main modes:
1.  **Normal Mode:** For navigation and commands (default). You cannot type text here.
2.  **Insert Mode:** For typing text.

## 3. Basic Commands

### Opening a file
```bash
vim myfile.txt
```

### Switching Modes
*   **Normal -> Insert:** Press `i`
*   **Insert -> Normal:** Press `Esc`

### Navigation (Normal Mode)
*   `h`, `j`, `k`, `l`: Left, Down, Up, Right (or use arrow keys).
*   `gg`: Go to top of file.
*   `G`: Go to bottom of file.

### Saving and Quitting (Normal Mode)
*   `:w` - Save (Write).
*   `:q` - Quit.
*   `:wq` - Save and Quit.
*   `:q!` - Quit without saving (Force quit).

## Hands-on Exercise 3
1.  Open a new file: `vim vim_test.txt`.
2.  Press `i` to enter Insert Mode.
3.  Type: "This is my first vim file."
4.  Press `Esc` to go back to Normal Mode.
5.  Type `:wq` and press Enter to save and exit.
6.  Open the file again (`vim vim_test.txt`) and verify the content.
