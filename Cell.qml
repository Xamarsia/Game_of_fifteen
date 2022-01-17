import QtQuick 2.0

Rectangle {
    id: root

    property alias text: label.text
    property int emptyCell: 0
    signal horizontalMove();
    signal verticalMove();
    color: "#00ffffff"

    function getColumn(index){
        if(index > 15 || index < 0)
        {
            return -1;
        }
        return (index / 4) | 0;
    }

    function getRow(index){
        if(index > 15 || index < 0)
        {
            return -1;
        }
        return index % 4;
    }

    MouseArea {
        anchors.fill: parent
        onClicked:{
            if((Math.abs(getRow(model.index) - getRow(emptyCell)) != 1 ) &&
               (Math.abs(getColumn(model.index) - getColumn(emptyCell)) != 1)){}

            else if(Math.abs(getRow(model.index) - getRow(emptyCell)) == 1 &&
                    Math.abs(getColumn(model.index) - getColumn(emptyCell)) == 0){
                root.horizontalMove();
            }
            else if(Math.abs(getColumn(model.index) - getColumn(emptyCell)) != 0 &&
                    Math.abs(getRow(model.index) - getRow(emptyCell)) == 0 ){
                root.verticalMove();
            }
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

