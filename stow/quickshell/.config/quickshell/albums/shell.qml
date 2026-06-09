import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets

// Album picker overlay. Summoned via `qs -c albums ipc call picker toggle`.
// Reads ~/.cache/albums/albums.json (written by album-picker-refresh) and
// opens selections in the Apple Music PWA via the local listener on :9111.
//
// Omarchy 4 port (when omarchy-shell ships — basecamp/omarchy#5856): this
// becomes a plugin in ~/.config/omarchy/plugins/albums/ with a manifest.json
// declaring kinds: ["menu"]. ShellRoot/PanelWindow/IpcHandler stay as-is;
// the summon path changes to `omarchy-shell shell toggle <id>` (drop the
// standalone daemon, its autostart line, and the album-picker wrapper's
// daemon bootstrap), and the hardcoded colors below should move to theme
// tokens (Color.menu.*, Style.cornerRadius) so the picker restyles with
// `omarchy theme set`. See docs/omarchy-shell.md on the omarchy-4 branch.
ShellRoot {
  id: root

  property bool shown: false
  property int  sel: 0

  readonly property int cell: 172
  readonly property int cellGap: 16
  readonly property int columns: 4
  readonly property int labelH: 40

  readonly property var albums: {
    try { return JSON.parse(dataFile.text() || "[]") } catch (e) { return [] }
  }
  readonly property var sections: {
    const names = []
    const groups = {}
    for (const a of albums) {
      if (!groups[a.section]) { names.push(a.section); groups[a.section] = [] }
      groups[a.section].push(a)
    }
    let base = 0
    return names.map(n => {
      const s = { name: n, items: groups[n], base: base }
      base += groups[n].length
      return s
    })
  }

  function launch(album) {
    if (!album) return
    opener.command = ["curl", "-sf", "-G", "http://127.0.0.1:9111/", "--data-urlencode", "url=" + album.url]
    opener.running = true
    root.shown = false
  }

  function move(delta) {
    if (albums.length === 0) return
    sel = Math.max(0, Math.min(albums.length - 1, sel + delta))
  }

  FileView {
    id: dataFile
    path: Quickshell.env("HOME") + "/.cache/albums/albums.json"
    watchChanges: true
    onFileChanged: reload()
  }

  Process { id: opener }

  IpcHandler {
    target: "picker"

    function toggle(): void {
      root.shown = !root.shown
      if (root.shown) root.sel = 0
    }
    function hide(): void { root.shown = false }
  }

  PanelWindow {
    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    visible: root.shown

    WlrLayershell.keyboardFocus: root.shown ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "albums-picker"

    // Dimmed backdrop; click outside the panel dismisses
    Rectangle {
      anchors.fill: parent
      color: "#a0000000"

      TapHandler { onTapped: root.shown = false }
    }

    Item {
      anchors.fill: parent
      focus: true

      Keys.onPressed: event => {
        switch (event.key) {
        case Qt.Key_Escape:                    root.shown = false; break
        case Qt.Key_Left:  case Qt.Key_H:      root.move(-1); break
        case Qt.Key_Right: case Qt.Key_L:      root.move(1); break
        case Qt.Key_Up:    case Qt.Key_K:      root.move(-root.columns); break
        case Qt.Key_Down:  case Qt.Key_J:      root.move(root.columns); break
        case Qt.Key_Return: case Qt.Key_Enter: case Qt.Key_Space:
          root.launch(root.albums[root.sel]); break
        case Qt.Key_A:                         root.launch(root.albums[10]); break
        case Qt.Key_B:                         root.launch(root.albums[11]); break
        default:
          if (event.key >= Qt.Key_1 && event.key <= Qt.Key_9)
            root.launch(root.albums[event.key - Qt.Key_1])
          else if (event.key === Qt.Key_0)
            root.launch(root.albums[9])
          else
            return
        }
        event.accepted = true
      }

      Rectangle {
        anchors.centerIn: parent
        border.color: "#28ffffff"
        border.width: 1
        color: "#f2141414"
        height: body.height + 56
        radius: 20
        width: body.width + 64

        Column {
          id: body
          anchors.centerIn: parent
          spacing: 22

          Repeater {
            model: root.sections

            Column {
              id: section
              required property var modelData
              spacing: 10

              Text {
                color: "#80ffffff"
                font.letterSpacing: 2
                font.pixelSize: 12
                font.weight: Font.DemiBold
                text: section.modelData.name.toUpperCase()
              }

              Grid {
                columns: root.columns
                columnSpacing: root.cellGap
                rowSpacing: root.cellGap

                Repeater {
                  model: section.modelData.items

                  Item {
                    id: card
                    required property int index
                    required property var modelData

                    readonly property int globalIndex: section.modelData.base + index
                    readonly property bool current: root.sel === globalIndex

                    height: root.cell + root.labelH
                    width: root.cell

                    Rectangle {
                      id: artFrame
                      border.color: card.current ? "#ffffff" : "#20ffffff"
                      border.width: card.current ? 3 : 1
                      color: "#1fffffff"
                      height: root.cell
                      radius: 12
                      scale: card.current ? 1.0 : 0.97
                      width: root.cell

                      Behavior on scale { NumberAnimation { duration: 90 } }

                      Text {
                        anchors.centerIn: parent
                        color: "#40ffffff"
                        font.pixelSize: 40
                        text: "♫"
                      }

                      ClippingRectangle {
                        anchors.fill: parent
                        anchors.margins: artFrame.border.width
                        color: "transparent"
                        radius: 12 - artFrame.border.width

                        Image {
                          anchors.fill: parent
                          asynchronous: true
                          fillMode: Image.PreserveAspectCrop
                          source: "file://" + card.modelData.art
                          sourceSize { height: root.cell * 2; width: root.cell * 2 }
                        }
                      }

                      Rectangle {
                        anchors { left: parent.left; leftMargin: 8; top: parent.top; topMargin: 8 }
                        color: "#c0000000"
                        height: 22
                        radius: 6
                        visible: card.globalIndex < 12
                        width: 22

                        Text {
                          anchors.centerIn: parent
                          color: "#ffffff"
                          font.pixelSize: 12
                          font.weight: Font.DemiBold
                          text: "1234567890AB".charAt(card.globalIndex)
                        }
                      }

                      Rectangle {
                        anchors { right: parent.right; rightMargin: 10; top: parent.top; topMargin: 10 }
                        color: "#e8d08770"
                        height: 8
                        radius: 4
                        visible: card.modelData.pinned === true
                        width: 8
                      }
                    }

                    Column {
                      anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
                      height: root.labelH - 6
                      spacing: 1

                      Text {
                        color: "#ffffff"
                        elide: Text.ElideRight
                        font.pixelSize: 12
                        font.weight: Font.DemiBold
                        text: card.modelData.artist
                        width: root.cell
                      }

                      Text {
                        color: "#90ffffff"
                        elide: Text.ElideRight
                        font.pixelSize: 11
                        text: card.modelData.title
                        width: root.cell
                      }
                    }

                    HoverHandler { onHoveredChanged: if (hovered) root.sel = card.globalIndex }
                    TapHandler { onTapped: root.launch(card.modelData) }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
