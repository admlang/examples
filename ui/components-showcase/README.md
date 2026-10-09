# Components showcase

A window with the `std.ui` components that work today, drawn in the colours of the desktop's
theme.

```
adm run ui/components-showcase/showcase.adm
```

| Section | Shows |
|---|---|
| Window, theme and tray | the window's icon (`WindowConfig.icon`, drawn on a `Canvas`); buttons that make `UI.theme()` light, dark or the desktop's (`Theme.follow`); `UI.showTray` with a menu that shows, hides and quits; minimize (`Window.state`), hide to tray (`Window.visible`), and closing to the tray (`UI.closeRequested`, `cancel`) |
| Text | `Text` wrapping in the window's width; ranges styled apart with `TextRun` |
| Buttons | `Button` idle, under the pointer, pressed, focused and disabled; a click, Tab and Shift+Tab between them, Space or Enter on the focused one |
| Pressable | `Pressable` making a `Panel` and its text something to click |
| Text fields | `TextField`: caret, selection with the pointer and the keys, clipboard, a placeholder, a password field |
| Label, search field and text area | `Label` focusing the control after it; `TextArea`: several lines, Up and Down, Page Up and Page Down, the wheel; `SearchField` with a magnifier, and a cross at its end and Escape that empty it |
| Menus and tooltips | a `tooltip` on a button, shown when the pointer rests on it or Tab reaches it; `Menu` under a button and `ContextMenu` on the secondary button, both with the arrows moving among their lines |
| Menu bar | `MenuBar` with two `Menu`s, a `MenuSeparator` and a `SubMenu`, lines with icons and shortcuts that work as keys: a press opens one, the pointer or Left and Right move to the other |
| Number field, combo box and split button | `NumberField` with two arrows inside the field and Up and Down; `ComboBox` listing the cities that hold what is typed; `SplitButton` with a menu behind its arrow |
| Icons and pointer shapes | `Icon` by name from std's set; an icon on a `Button`; the pointer changing over a `Link`, text fields and the split pane's divider |
| Chip, avatar, hover card and toast | `Chip` with a cross, `Avatar` with initials, a `HoverCard` the pointer can go into, a `Tooltip` with content on the Save button, a `Toast` in the window's corner |
| Accordion and canvas | `Accordion` with two `AccordionItem`s; a `Canvas` drawn by a function on every frame |
| Split pane and tabs | `SplitPane` with a divider to drag; `Tabs` showing one `Tab` at a time under its strip |
| Popover | `Popover` under a button: it opens over the page, and Escape or a press outside closes it |
| Rows and columns | `Row` and `Column` with their `gap` |
| Scrolling | the whole page is in a `ScrollView`: turn the wheel, drag the bar's thumb, click beside it for a page, or focus a button and use Page Up, Page Down, Home, End and the arrows  |
| Palette | the colours of `UI.theme().palette`, drawn by a component with its own `render` |

Switch the desktop between light and dark, or change its accent colour, while the window is
open: the palette and the components follow.

The showcase keeps its state in one `@bindable` object: a control given one of its fields
(`Checkbox(checked = counter.agreed)`) writes what the user sets straight into it, so there is
no handler that copies a value back.

The counts in the text change because a view passes its arguments again on every frame; the
squares under the buttons are drawn by a component's own `render`.
