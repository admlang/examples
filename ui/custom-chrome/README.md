# Custom chrome

Two windows whose frames the program draws itself.

```
adm run ui/custom-chrome/chrome.adm
```

A window's frame (its border, its header, its buttons) is its chrome. `WindowConfig.chrome`
is none by default, and the desktop draws the frame. Set to a component, the window opens
without the desktop's frame and that component is the frame: it draws what it wants, in any
shape, and the window's root goes where its view calls `children()`.

```adm
let config = new renderer.WindowConfig("Custom chrome", 460, 340)
config.transparent = true
config.chrome = CardChrome(title = "Custom chrome")
try await UI.run(Page(), config)
```

| Part | Shows |
|---|---|
| `CardChrome` | a chrome written from scratch: a rounded frame (`radius`, with the window `transparent` so the desktop shows around the corners), a header in a `WindowDrag` that moves the window, three dots that close, minimize and maximize |
| `Dot` | a round button that draws itself; it is `focusable`, which is what makes a press on it the button's and not a drag of the window it sits in the header of |
| `RoundChrome` | a chrome with no buttons: a disc, all of it moving the window; `clickThrough = ClickThrough.Empty` sends presses outside the disc to what is behind |
| `context<Window>()` | how a component finds the window it is in: the dots assign `window.state` and call `window.close()`, the page shows its window's state |
| `UI.window(name = "round")` | finding another window by the name it was opened with (`WindowConfig.name`): the first window opens the round one once and closes it |

`std.ui.components::WindowChrome` is the chrome std provides, with a title and the usual
three buttons; the components showcase opens a window with it.
