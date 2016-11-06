
import VPlay 2.0
import QtQuick 2.0

Item {
    id: item

    property int cellSize: 20
    property int cellX: 0
    property int cellY: 0

    x: cellX * cellSize
    y: cellY * cellSize

    Cell {cellX: 0; cellY: 0}
    Cell {cellX: 0; cellY: 1}
    Cell {cellX: 1; cellY: 1}
    Cell {cellX: 1; cellY: 2}

}
