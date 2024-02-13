import QtQuick 2.15
import QtQuick.Window 2.15

Item
{
    id: root
    property int leftTopBorderRadius     : 0
    property int rightTopBorderRadius    : 0
    property int rightBottomBorderRadius : 0
    property int leftBottomBorderRadius  : 0

    property string color: "#333333"

    Rectangle {
        id: leftTopBorder
        anchors.left: parent.left
        anchors.top: parent.top
        width: parent.width/2
        height: parent.height/2
        color: "transparent"
        clip: true

        Rectangle {
            anchors.right: parent.right
            anchors.rightMargin: -parent.width
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -parent.height
            width: parent.width*2
            height: parent.height*2
            color: root.color
            radius: leftTopBorderRadius > 0 ? leftTopBorderRadius : parent.radius
        }
    }

    Rectangle {
        id: rightTopBorder
        anchors.right: parent.right
        anchors.top: parent.top
        width: parent.width/2
        height: parent.height/2
        color: "transparent"
        clip: true

        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: -parent.width
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -parent.height
            width: parent.width*2
            height: parent.height*2
            color: root.color
            radius: rightTopBorderRadius > 0 ? rightTopBorderRadius : parent.radius
        }
    }

    Rectangle {
        id: rightBottomBorder
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: parent.width/2
        height: parent.height/2
        color: "transparent"
        clip: true

        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: -parent.width
            anchors.top: parent.top
            anchors.topMargin: -parent.height
            width: parent.width*2
            height: parent.height*2
            color: root.color
            radius: rightBottomBorderRadius > 0 ? rightBottomBorderRadius : parent.radius
        }
    }

    Rectangle {
        id: leftBottomBorder
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: parent.width/2
        height: parent.height/2
        color: "transparent"
        clip: true

        Rectangle {
            anchors.right: parent.right
            anchors.rightMargin: -parent.width
            anchors.top: parent.top
            anchors.topMargin: -parent.height
            width: parent.width*2
            height: parent.height*2
            color: root.color
            radius: leftBottomBorderRadius > 0 ? leftBottomBorderRadius : parent.radius
        }
    }
}
