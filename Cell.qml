import QtQuick 2.0

Rectangle {
    id: root
    signal itemCliced();

    property alias text: label.text
    signal cliced()
    color: "#00ffffff"

    signal horizontalMove();
    signal verticalMove();
    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.itemCliced()
        }
    }
    Rectangle {
        radius: 10
        color: "orange"
        anchors.fill: parent
        anchors.margins: 3
        border.color: Qt.darker("orange", 2)

        Text {
            id: label

            color: "black"
            font.pixelSize: 24
            anchors.centerIn: parent
        }
    }
}

