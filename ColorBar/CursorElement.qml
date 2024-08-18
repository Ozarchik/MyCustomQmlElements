import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3

Rectangle {
    id: root
    width: 20
    height: 20
    anchors.left: parent.right

    signal removeRequest();
    signal updateRequest(string changedColor);

    color: cursorColor
    property color cursorColor: "blue"

    property real startY: 0
    property real yPosition: 0

    property alias mouseArea: mouseArea

    property GradientStop associatedStop: null

    onYPositionChanged: {
        if (associatedStop) {
            associatedStop.position = yPosition / parent.height;
        }
    }

    onCursorColorChanged: {
        if (associatedStop) {
            associatedStop.color = cursorColor;
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        drag.target: parent
        drag.smoothed: true
        drag.axis: "YAxis"
        drag.minimumY: 0
        drag.maximumY: root.parent.height - root.height
    }

    MouseArea {
        id: colorBarMouseArea
        anchors.fill: parent
        acceptedButtons: Qt.RightButton

        onReleased: mouse => {
            if (mouse.button === Qt.RightButton) {
                addMenu.popup(mouse.x, mouse.y)
            }
        }

        Menu {
            id: addMenu
            MenuItem {
                text: "Change color"
                onTriggered: {
                    colorDialog.open()
                }
            }
            MenuItem {
                text: "Remove Cursor"
                onTriggered: {
                    removeRequest();
                }
            }
        }
    }

    function openColorDialog() {
        colorDialog.open()
    }


    Window {
        id: window
        width: 600
        height: 600

        ColorDialog {
            id: colorDialog
            visible: false
            modality: Qt.ApplicationModal

            title: "Please choose a color"

            onAccepted: {
                console.log("You chose: " + colorDialog.color)
            }
            onRejected: {
                console.log("Canceled")
            }

            onCurrentColorChanged: {
                updateRequest(currentColor);
            }

            onVisibleChanged: {

                var globalPoint = root.parent.mapToGlobal(root.parent.width, 0);
                var newPoint = Qt.point(globalPoint.x + 100, globalPoint.y +  50)
                window.x = newPoint.x
                window.y = newPoint.y
            }
        }

        Component.onCompleted: {
            var point = root.mapToItem(root.parent, root.width / 2, root.height / 2);

            window.x = point.x - 1000 // window.width / 2;
            window.y = point.y - window.height / 2;
        }

        onXChanged: {
            // console.log("-- FROM GLOBAL -- ", root.parent.mapFromGlobal(root.parent.x, root.parent.y))
            // console.log("-- TO GLOBAL-- ", root.parent.mapToGlobal(root.parent.x, root.parent.y))
            // console.log("-- FROM ITEM-- ", root.parent.mapFromItem(root.parent, x, y), " x: ", x, " y: ", y)
            // console.log("-- TO ITEM-- ", root.parent.mapToItem(root.parent, x, y), " x: ", x, " y: ", y)
            // console.log("-- TO ITEM-- ", root.parent.mapFromItem(root.parent.x, root.parent.y))
        }
    }
}
