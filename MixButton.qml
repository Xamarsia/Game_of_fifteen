import QtQuick 2.0
//#include <QList>

Rectangle {
    id: root

    width: 160
    height: 84
    color: "khaki"
    signal cliced();

    Rectangle {
        width: 140
        height: 64

        radius: 45
        color: "orange"
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        anchors.bottomMargin: 20
        border.color: Qt.darker("orange", 2)

    Text {
        text: qsTr("Mix")
        font.pixelSize: 24
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.cliced();
            }
        }
    }
}
