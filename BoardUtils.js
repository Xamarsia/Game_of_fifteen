.pragma library

function getColumn(index, rowsCount, columnsCount) {
    if(index > ((rowsCount*columnsCount)-1) || index < 0) {
        return -1;
    }
    return index % columnsCount;
}

function getRow(index, rowsCount, columnsCount) {
    if(index > ((rowsCount*columnsCount)-1) || index < 0) {
        return -1;
    }
    return (index / columnsCount) | 0;
}

