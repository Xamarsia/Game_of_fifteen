import QtQuick 2.0
import QtQml.Models 2.15
import QtQuick.Controls 2.12

import "BoardUtils.js" as BoardUtils

Rectangle {
    id: root

    property int emptyCellIndex: 0
    readonly property int rowsCount: 4
    readonly property int columnsCount: 4

    Component.onCompleted: root.mix()

    anchors.margins: 20
    color: "khaki"

    function getInversionsCount() {
        var invCount = 0;
        for(var i = 0; i < rowsCount * columnsCount ; i++) {
            if (gridModel.get(i).value) {
                for (var j = 0; j < i; ++j) {
                    if(gridModel.get(i).value > gridModel.get(j).value) {
                        ++invCount;
                    }
                }
            } else {
                invCount +=  i/rowsCount
            }
        }
        return invCount;
    }

    function isSolvable() {
        for(var i = 0; i < (rowsCount*columnsCount - 1) ; i++) {
            var invCount = getInversionsCount();
            return !(invCount & 1)
        }
    }

    function userWon() {
        if(emptyCellIndex == 0) {
            return 0
        }
        for(var i = 0; i < (gridModel.count - 2) ; i++) {
            if(gridModel.get(i).value > gridModel.get(i+1).value) {
                return 0
            }
        }
        return 1
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
        if(userWon()) {
            mix()
        }
        if(!isSolvable()) {
            mix()
        }
    }

    function moveEmptyItemDown() {
        if(emptyCellIndex + columnsCount < (rowsCount * columnsCount)) {
            gridModel.move(emptyCellIndex, emptyCellIndex + (columnsCount-1), 1)
            gridModel.move(emptyCellIndex + columnsCount, emptyCellIndex, 1)
            emptyCellIndex = emptyCellIndex + columnsCount
        }
    }

    function moveEmptyItemLeft() {
        if((emptyCellIndex) % columnsCount != 0) {
            gridModel.move(emptyCellIndex - 1, emptyCellIndex, 1)
            emptyCellIndex = emptyCellIndex - 1
        }
    }

    function moveEmptyItemRight() {
        if((emptyCellIndex+1) % columnsCount != 0) {
            gridModel.move(emptyCellIndex + 1, emptyCellIndex, 1)
            emptyCellIndex = emptyCellIndex + 1
        }
    }

    function moveEmptyItemUp() {
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

            Dialog {
                id: victoryDialog

                x: (parent.width - width) / 2
                y: (parent.height - height) / 2
                parent: Overlay.overlay
                modal: true
                title: "Restart the game"
                standardButtons: Dialog.Close | Dialog.Reset

                Column {
                    anchors.fill: parent
                    spacing: 4
                    Label {
                        text: "Сongratulations!"
                        color: "red"
                        font.pixelSize: 24
                    }
                    Label {
                        text: "You are a winner"
                        font.pixelSize: 18
                    }
                }

                onReset: {
                     board.mix();
                     victoryDialog.close()
                }
            }

            delegate: Cell {
                id: cell

                text: model.value
                width: grid.cellWidth
                height: grid.cellHeight
                opacity: (model.value !== 0) ? 1 : 0

                onItemCliced: {
                    var rowDistance = BoardUtils.getRow(model.index, rowsCount, columnsCount) - BoardUtils.getRow(emptyCellIndex, rowsCount, columnsCount)
                    var columnDistance = BoardUtils.getColumn(model.index, rowsCount, columnsCount) - BoardUtils.getColumn(emptyCellIndex, rowsCount, columnsCount)

                    if(Math.abs(rowDistance) == 1 && columnDistance == 0) {

                        if(BoardUtils.getRow(model.index, rowsCount, columnsCount) < BoardUtils.getRow(emptyCellIndex, rowsCount, columnsCount)) {
                            moveEmptyItemUp()
                        } else {
                            moveEmptyItemDown()
                        }

                        if(userWon() && emptyCellIndex != 0){
                            victoryDialog.open()
                        }
                    } else if(Math.abs(columnDistance) == 1 && rowDistance == 0 ) {

                        if(BoardUtils.getColumn(model.index, rowsCount, columnsCount) < BoardUtils.getColumn(emptyCellIndex, rowsCount, columnsCount)) {
                            moveEmptyItemLeft()
                        } else {
                            moveEmptyItemRight()
                        }

                        if(userWon() && emptyCellIndex != 0){
                            victoryDialog.open()
                        }
                    }
                }
            }
        }
    }
}
