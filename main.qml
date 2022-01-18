import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15

Window {
    id: root;

    width: 500
    height: 500
    visible: true
    title: qsTr("Hello World")

    Background{
        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent
            spacing: 2

            Board {
                id: board

                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            MixButton {
               Layout.alignment: Qt.AlignHCenter
               onCliced: board.mix();
            }
        }
    }
}



