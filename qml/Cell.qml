
import VPlay 2.0
import QtQuick 2.0

Rectangle {
    id: item
    color: "blue"

    property int cellSize: 20
    property int cellX: 0
    property int cellY: 0

    x: cellX * cellSize
    y: cellY * cellSize
    width: cellSize
    height: cellSize

    function set(x, y) {
        cellX = x
        cellY = y
    }
}
