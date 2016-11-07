
import VPlay 2.0
import QtQuick 2.0

Rectangle {
    id: figure

    property bool backVisible: false
    property color cellsColor: "lightblue"
    property int cellSize: 20
    property int cellX: 0
    property int cellY: 0
    property int type: 0

    color: backVisible ? "white" : "transparent"

    x: cellX * cellSize
    y: cellY * cellSize
    height: cellSize * 4
    width: cellSize * 4

    Cell { id: c1; cellX: 0; cellY: 1; cellSize: figure.cellSize; color: figure.cellsColor }
    Cell { id: c2; cellX: 1; cellY: 1; cellSize: figure.cellSize; color: figure.cellsColor }
    Cell { id: c3; cellX: 2; cellY: 1; cellSize: figure.cellSize; color: figure.cellsColor }
    Cell { id: c4; cellX: 3; cellY: 1; cellSize: figure.cellSize; color: figure.cellsColor }

    onTypeChanged: {
        switch( type ) {
        case 0: // space
            c1.set(0, 1); c2.set(1, 1); c3.set(2, 1); c4.set(3, 1)
            break;
        case 1: // --|
            c1.set(0, 1); c2.set(1, 1); c3.set(2, 1); c4.set(2, 2)
            break;
        case 2: // -|-
            c1.set(0, 1); c2.set(1, 1); c3.set(1, 2); c4.set(2, 1)
            break;
        case 3: // |--
            c1.set(0, 1); c2.set(0, 2); c3.set(1, 1); c4.set(2, 1)
            break;
        case 4: // --__
            c1.set(0, 1); c2.set(1, 1); c3.set(1, 2); c4.set(2, 2)
            break;
        case 5: // ==
            c1.set(1, 1); c2.set(1, 2); c3.set(2, 1); c4.set(2, 2)
            break;
        case 6: // __--
            c1.set(0, 2); c2.set(1, 2); c3.set(1, 1); c4.set(2, 1)
            break;
        }
    }

    function nextType() {
        type = Math.random() * 7
    }

    function rotateFigure() {
        for(var j=0;j<figure.children.length;j++){
            var cell = figure.children[j]
            var centerX = cell.cellX
            var centerY = cell.cellY
            cell.cellX = 3 - centerY
            cell.cellY = centerX
        }
    }
}
