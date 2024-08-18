import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    id: window
    width: 800
    height: 800
    visible: true
    title: qsTr("Hello World")


    ListModel {
        id: stopsModel
        ListElement {
            position: 0
            color: "green"
        }
        ListElement {
            position: 0.5
            color: "red"
        }
        ListElement {
            position: 1
            color: "black"
        }
    }



    Rectangle {
        id: _colorBar
        anchors.centerIn: parent
        // anchors.left: parent.left
        width: 40
        height: 500

        gradient: Gradient {
            id: gradient
            Component.onCompleted: {
                initGradientStops();
            }
        }


        Repeater {
            id: repeater
            model: stopsModel
            CursorElement {
                required property int index
                required property var model

                y: model.position
                onYChanged: {
                    updateGradientStopPosition(index);
                }

                onUpdateRequest: {
                    updateGradientStopColor(index, changedColor);
                }

                onRemoveRequest: {
                    removeGradientStop(index)
                }

                Component.onCompleted: {
                    var pos = (stopsModel.get(index).position * parent.height) - height
                    y = pos < 0 ? 0 : pos
                }
            }
        }


        MouseArea {
            id: colorBarMouseArea
            anchors.fill: parent
            acceptedButtons: Qt.RightButton

            onReleased: mouse => {
                if (mouse.button === Qt.RightButton) {
                    addMenu.popup(mouse.x + 25 , mouse.y - 15)
                }
            }

            Menu {
                id: addMenu
                MenuItem {
                    text: "Add Cursor"
                    onTriggered: {
                        var lastColor = "transparent"
                        if (stopsModel.count) {
                            lastColor = stopsModel.get(stopsModel.count - 1).color
                        }
                        var cursorElement = repeater.itemAt(stopsModel.count - 1);
                        cursorElement.openColorDialog();
                        stopsModel.append({position: colorBarMouseArea.mouseY/colorBarMouseArea.height, color: lastColor})
                        resetGradientStops();
                    }
                }
                MenuItem {
                    text: "Remove last cursor"
                    onTriggered: {
                        var stopColor = "" + Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
                        stopsModel.remove(stopsModel.count - 1)
                        resetGradientStops();
                    }
                }
                MenuItem {
                    text: "Remove all cursors"
                    onTriggered: {
                        removeAllGradientStops()
                    }
                }
            }
        }
    }


    function initGradientStops() {
        gradient.stops = [];
        for (var i = 0; i < stopsModel.count; i++) {
            var stopGradient = stopsModel.get(i)
            var newStop = Qt.createQmlObject('import QtQuick 2.15; GradientStop { color: "' + stopGradient.color + '"; position: ' + stopGradient.position + ' }', gradient);

            gradient.stops.push(newStop);
        }
    }


    function updateGradientStops() {
        for (var i = 0; i < stopsModel.count; i++) {
            if (gradient.stops[i]) {
                gradient.stops[i].position = repeater.itemAt(i).y/repeater.itemAt(i).parent.height
            }
        }
    }

    function updateGradientStopPosition(index) {
        if (index < gradient.stops.length && gradient.stops.length > 0) {
            gradient.stops[index].position = repeater.itemAt(index).y/repeater.itemAt(index).parent.height
        }
    }

    function updateGradientStopColor(index, color) {
        if (index < stopsModel.count) {
            stopsModel.get(index).color = color
            gradient.stops[index].color = color
        }
    }

    function resetGradientStops() {
        gradient.stops = [];
        for (var i = 0; i < stopsModel.count; i++) {
            var stopGradient = stopsModel.get(i)
            var newStop = Qt.createQmlObject('import QtQuick 2.15; GradientStop { color: "' + stopGradient.color + '"; position: ' + repeater.itemAt(i).y/_colorBar.height + ' }', gradient);
            gradient.stops.push(newStop);
        }
        updateGradientStops();
    }

    function removeAllGradientStops() {
        for (var i = stopsModel.count - 1; i > 0; i--)
            removeGradientStop(i)
        resetGradientStops()
    }

    function removeGradientStop(index) {
        if (stopsModel.count > 1) {
            stopsModel.remove(index)
            resetGradientStops()
        }
    }
}
