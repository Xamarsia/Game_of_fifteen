import QtQuick 2.0
import QtQml.Models 2.15

Rectangle {
    id: root

    property int emptyCellIndex: 0
    property int rowsCount: 2
    property int columnsCount: 4

    anchors.margins: 20
    color: "khaki"

    function getColumn(index) {
        if(index > ((rowsCount*columnsCount)-1) || index < 0)
        {
            return -1;
        }
        return index - getRow(index) * columnsCount;
    }

    function getRow(index) {
        if(index > ((rowsCount*columnsCount)-1) || index < 0)
        {
            return -1;
        }
        return (index / columnsCount) | 0;
    }

    function mix() {
        var items = []
        for(var j = 0; j < rowsCount*columnsCount ; j++) {
            items.push(j)
        }

        gridModel.clear()
        while(items.length != 0) {

            var i = Math.floor(Math.random() * items.length)
            var item = items[i]
            if(item === 0) {
                emptyCellIndex = gridModel.count
            }
            gridModel.append({"value": items[i]})
            items[i] = items[items.length - 1]
            items[items.length - 1] = item
            items.pop()
        }
    }

    function moveEmptyItemDown() {
        console.log("Down")
        if(emptyCellIndex + columnsCount < (rowsCount * columnsCount)) {
            gridModel.move(emptyCellIndex, emptyCellIndex + (columnsCount-1), 1)
            gridModel.move(emptyCellIndex + columnsCount, emptyCellIndex, 1)
            emptyCellIndex = emptyCellIndex + columnsCount
        }
    }

    function moveEmptyItemLeft() {
        console.log("Left")
        if((emptyCellIndex) % columnsCount != 0) {
            gridModel.move(emptyCellIndex - 1, emptyCellIndex, 1)
            emptyCellIndex = emptyCellIndex - 1
        }
    }

    function moveEmptyItemRight() {
        console.log("Right")
        if((emptyCellIndex+1) % columnsCount != 0) {
            gridModel.move(emptyCellIndex + 1, emptyCellIndex, 1)
            emptyCellIndex = emptyCellIndex + 1
        }
    }

    function moveEmptyItemUp() {
        console.log("Up")
        if(emptyCellIndex - columnsCount >= 0) {
            gridModel.move(emptyCellIndex, emptyCellIndex - (columnsCount-1), 1)
            gridModel.move(emptyCellIndex - columnsCount, emptyCellIndex, 1)
            emptyCellIndex = emptyCellIndex - columnsCount
        }
    }

    Rectangle {
        anchors.margins: 20
        anchors.fill: parent
        border.color: Qt.darker("orange", 2)

        GridView {
            id: grid

            interactive: false
            model: ListModel {
                id: gridModel
            }

            anchors.fill: parent
            anchors.margins: 5
            cellHeight: height / rowsCount
            cellWidth: width / columnsCount

            move: Transition {
                NumberAnimation { properties: "x"; duration: 500 }
                NumberAnimation { properties: "y"; duration: 500 }
            }

            delegate: Cell {
                id: cell
                text: model.value
                width: grid.cellWidth
                height: grid.cellHeight
                opacity: (model.value !== 0) ? 1 : 0
                onItemCliced: {
                    var rowDistance = getRow(model.index) - getRow(emptyCellIndex)
                    var columnDistance = getColumn(model.index) - getColumn(emptyCellIndex)

                    if(Math.abs(rowDistance) == 1 && columnDistance == 0) {

                        if(getRow(model.index) < getRow(emptyCellIndex)) {
                            moveEmptyItemUp()
                        }
                        else {
                            moveEmptyItemDown()
                        }
                    }

                    else if(Math.abs(columnDistance) == 1 && rowDistance == 0 ) {

                        if(getColumn(model.index) < getColumn(emptyCellIndex)) {
                            moveEmptyItemLeft()
                        }
                        else {
                            moveEmptyItemRight()
                        }
                    }
                }
            }
        }
    }
}
