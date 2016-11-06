
import VPlay 2.0
import QtQuick 2.0

Rectangle {
    id: figure

    property int cellSize: 20
    property int cellX: 0
    property int cellY: 0

    x: cellX * cellSize
    y: cellY * cellSize
    height: cellSize * 3
    width: cellSize * 2

    Cell {cellX: 0; cellY: 0; cellSize: figure.cellSize}
    Cell {cellX: 0; cellY: 1; cellSize: figure.cellSize}
    Cell {cellX: 1; cellY: 1; cellSize: figure.cellSize}
    Cell {cellX: 1; cellY: 2; cellSize: figure.cellSize}

}
