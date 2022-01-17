import QtQuick 2.0
import QtQml.Models 2.15

Rectangle {
    id: root
    anchors.margins: 20
    color: "khaki"

    property int emptyInex: -1
    onEmptyInexChanged: console.debug("onEmptyInexChanged:", onEmptyInexChanged)

    function moveCurrentItemDown(){
        if(grid.currentIndex + 4 <= 15){
            gridModel.move(grid.currentIndex, grid.currentIndex + 3, 1)
            gridModel.move(grid.currentIndex + 4, grid.currentIndex, 1)
        }
    }
    function moveCurrentItemLeft(){
        if((grid.currentIndex) % 4 != 0){
            gridModel.move(grid.currentIndex - 1, grid.currentIndex, 1)
        }
    }

    function moveCurrentItemRight(){
        if((grid.currentIndex+1) % 4 != 0){
            gridModel.move(grid.currentIndex + 1, grid.currentIndex, 1)
        }
    }

    function moveCurrentItemUp(){
        if(grid.currentIndex - 4 >= 0){
            gridModel.move(grid.currentIndex, grid.currentIndex - 3, 1)
            gridModel.move(grid.currentIndex - 4, grid.currentIndex, 1)
        }
    }

    Rectangle {
        anchors.margins: 20
        anchors.fill: parent
        border.color: Qt.darker("orange", 2)

        GridView {
        id: grid

        interactive: false
        model: gridModel
        anchors.fill: parent

        anchors.margins: 5

        cellHeight: height/4
        cellWidth: width/4

        move: Transition {
            NumberAnimation { properties: "x"; duration: 500 }
            NumberAnimation { properties: "y"; duration: 500 }
        }

        delegate: Cell{
                id: cell
                text: model.value
                width: grid.cellWidth
                height: grid.cellHeight
                opacity: (model.value != 0) ? 1 : 0
                emptyCell: grid.currentIndex

                onHorizontalMove: {
                    (grid.currentIndex > index)? root.moveCurrentItemLeft() : root.moveCurrentItemRight();
                }
                onVerticalMove: {
                   (grid.currentIndex > index) ? root.moveCurrentItemUp() : root.moveCurrentItemDown() ;
                }
            }
        }

        ListModel {
              id: gridModel
              ListElement {value: 0}
              ListElement {value: 1}
              ListElement {value: 2}
              ListElement {value: 3}
              ListElement {value: 4}
              ListElement {value: 5}
              ListElement {value: 6}
              ListElement {value: 7}
              ListElement {value: 8}
              ListElement {value: 9}
              ListElement {value: 10}
              ListElement {value: 11}
              ListElement {value: 12}
              ListElement {value: 13}
              ListElement {value: 14}
              ListElement {value: 15}
            }

        Keys.onRightPressed: {
            moveCurrentItemRight();
        }

        Keys.onLeftPressed: {
            moveCurrentItemLeft();
        }

        Keys.onUpPressed: {
            moveCurrentItemUp();
        }
        Keys.onDownPressed: {
            moveCurrentItemDown();
        }

        focus: true;
    }
}
