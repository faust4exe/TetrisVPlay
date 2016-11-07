
import VPlay 2.0
import QtQuick 2.0

Item {
    id: figure

    property int cellSize: 20
    property int cellX: 0
    property int cellY: 0
    property int type: 0

    x: cellX * cellSize
    y: cellY * cellSize
    height: cellSize * 3
    width: cellSize * 2

    Cell {id: c1; cellX: 0; cellY: 0; cellSize: figure.cellSize}
    Cell {id: c2; cellX: 1; cellY: 0; cellSize: figure.cellSize}
    Cell {id: c3; cellX: 2; cellY: 0; cellSize: figure.cellSize}
    Cell {id: c4; cellX: 3; cellY: 0; cellSize: figure.cellSize}

    onTypeChanged: {
        switch( type ) {
        case 0: // space
            c1.set(0, 0); c2.set(1, 0); c3.set(2, 0); c4.set(3, 0)
            break;
        case 1: // --|
            c1.set(0, 0); c2.set(1, 0); c3.set(2, 0); c4.set(2, 1)
            break;
        case 2: // -|-
            c1.set(0, 0); c2.set(1, 0); c3.set(1, 1); c4.set(2, 0)
            break;
        case 3: // |--
            c1.set(0, 0); c2.set(0, 1); c3.set(1, 0); c4.set(2, 0)
            break;
        case 4: // --__
            c1.set(0, 0); c2.set(1, 0); c3.set(1, 1); c4.set(2, 1)
            break;
        case 5: // ==
            c1.set(0, 0); c2.set(0, 1); c3.set(1, 0); c4.set(1, 1)
            break;
        case 6: // __--
            c1.set(0, 1); c2.set(1, 1); c3.set(1, 0); c4.set(2, 0)
            break;
        }
    }

    function nextType() {
        type = ++type % 7
    }

}
