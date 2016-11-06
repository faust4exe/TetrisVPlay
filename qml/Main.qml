import VPlay 2.0
import QtQuick 2.0

GameWindow {
    id: gameWindow

    // You get free licenseKeys from http://v-play.net/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the V-Play Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    //licenseKey: "<generate one from http://v-play.net/licenseKey>"

    activeScene: scene

    // the size of the Window can be changed at runtime by pressing Ctrl (or Cmd on Mac) + the number keys 1-8
    // the content of the logical scene size (480x320 for landscape mode by default) gets scaled to the window size based on the scaleMode
    // you can set this size to any resolution you would like your project to start with, most of the times the one of your main target device
    // this resolution is for iPhone 4 & iPhone 4S
    screenWidth: 640
    screenHeight: 960

    Scene {
        id: scene

        property int filledLines: 0
        property bool createFigureOnTimer: true
        property int cellsNumber: gridHeigth * gridWidth
        property int gridHeigth: height/cellSize
        property int gridWidth: width/cellSize
        property int cellSize: 20
        property var figures: []
        property var cells: []
        property var cellsTable: []
        property var lastFigure

        // the "logical size" - the scene content is auto-scaled to match the GameWindow size
        width: 320
        height: 480


        // background rectangle matching the logical scene size (= safe zone available on all devices)
        // see here for more details on content scaling and safe zone: http://v-play.net/doc/vplay-different-screen-sizes/
        Rectangle {
            id: rectangle
            anchors.fill: parent
            color: "grey"

            Text {
                id: scoreText
                text: qsTr("Filled lines: ") + scene.filledLines
                color: "#ffffff"
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                visible: mainTimer.running
            }

            Text {
                id: textElement
                // qsTr() uses the internationalization feature for multi-language support
                text: qsTr("Press to start")
                color: "#ffffff"
                anchors.centerIn: parent
                visible: !mainTimer.running
            }

            MouseArea {
                anchors.fill: parent

                // when the rectangle that fits the whole scene is pressed, change the background color and the text
                onPressed: {
                    mainTimer.running = true
                    textElement.text = qsTr("Scene-Rectangle is pressed at position " + Math.round(mouse.x) + "," + Math.round(mouse.y))
                    rectangle.color = "black"
                    console.debug("pressed position:", mouse.x, mouse.y)
                }

                onPositionChanged: {
                    textElement.text = qsTr("Scene-Rectangle is moved at position " + Math.round(mouse.x) + "," + Math.round(mouse.y))
                    console.debug("mouseMoved or touchDragged position:", mouse.x, mouse.y)
                }

                // revert the text & color after the touch/mouse button was released
                // also States could be used for that - search for "QML States" in the doc
                onReleased: {
                    textElement.text = qsTr("Press to start")
                    rectangle.color = "grey"
                    console.debug("released position:", mouse.x, mouse.y)
                }
            }
        }// Rectangle with size of logical scene

//        Figure{
//            id: figure
//            cellX: 4
//            cellY: 2
//            cellSize: scene.cellSize
//        }

//        Cell{
//            id:cell
//            cellX: 1
//            cellY: 1
//            cellSize: scene.cellSize
//        }

        Timer {
            id: mainTimer
            interval: 1000
            repeat: true
            onTriggered: {
                if ( scene.createFigureOnTimer ) {
                    scene.createFigureOnTimer = false
                    scene.addFigure()
                    scene.checkForFilledLines()
                }

                var i;
                var figure;
                var cell;
                for(i=0; i<scene.figures.length; i++) {
                    figure = scene.figures[i]
                    figure.cellY++
                }

                for(i=0; i<scene.figures.length; i++) {
                    figure = scene.figures[i]
                    var isDown = false
                    for(var j=0;j<figure.children.length;j++){
                        cell = figure.children[j]
                        if ( scene.isCellDown(cell) ) {
                            isDown = true
                            break;
                        }
                    }
                    if ( isDown ) {
                        scene.moveFigureToStatic(figure)
                    }
                }
            }
        }

        Keys.onLeftPressed:  lastFigure.cellX--
        Keys.onRightPressed: lastFigure.cellX++
        Keys.onUpPressed:   lastFigure.cellY--
        Keys.onDownPressed: lastFigure.cellY++

        Component.onCompleted: {
            for ( var x = 0; x < scene.gridWidth; x++) {
                for ( var y = 0; y < scene.gridHeigth; y++ ) {
                    scene.cellsTable[x + y * scene.gridWidth] = 0
                }
            }
        }

        function addFigure(){
            var component = Qt.createComponent("Figure.qml");
            if (component.status == Component.Ready) {
                var figure = component.createObject(scene);
                figure.cellX = 6
                figure.cellY = 0
                scene.figures.push(figure)
                lastFigure = figure
            }
        }

        function moveFigureToStatic(figure) {
            var index = scene.figures.indexOf(figure)
            scene.figures.splice(index, 1)

            for(var j=0;j<figure.children.length;j++){
                var cell = figure.children[j]
                scene.createStaticCellFrom(cell)
            }

            figure.destroy()
        }

        function createStaticCellFrom(oldcell){
            var component = Qt.createComponent("Cell.qml");
            if (component.status == Component.Ready) {
                var cell = component.createObject(scene);
                var absX = oldcell.cellX + oldcell.parent.cellX
                var absY = oldcell.cellY + oldcell.parent.cellY
                cell.cellX = absX
                cell.cellY = absY
                scene.cellsTable[absX + absY * scene.gridWidth] = cell
                scene.cells.push(cell)
                scene.createFigureOnTimer = true
            }
        }

        function isCellDown(cell) {
            var absX = cell.cellX + cell.parent.cellX
            var absY = cell.cellY + cell.parent.cellY
            if ( scene.cellsTable[absX + (absY+1) * scene.gridWidth] != 0) {
                return true;
            }

            return ((absY + 1) == scene.gridHeigth)
        }

        function checkForFilledLines() {
            for ( var y = 0; y < scene.gridHeigth; y++ ) {
                var isFull = true
                for ( var x = 0; x < scene.gridWidth; x++) {
                    if ( scene.cellsTable[x + y * scene.gridWidth] == 0) {
                        isFull = false
                        break
                    }
                }
                if ( isFull ) {
                    scene.filledLines++
                    removeFilledLine(y)
                }
            }
        }

        function removeFilledLine(filledY) {
            // remove the line
            var x
            for ( x = 0; x < scene.gridWidth; x++) {
                if ( scene.cellsTable[x + filledY * scene.gridWidth] != 0) {
                    var cell = scene.cellsTable[x + filledY * scene.gridWidth]
                    scene.cellsTable[x + filledY * scene.gridWidth] = 0
                    cell.destroy()
                }
            }
            // move down all the above lines
            for ( var y = filledY; y >= 0 ; y-- ) {
                var isFull = true
                for ( x = 0; x < scene.gridWidth; x++) {
                    if ( y == 0 )
                        scene.cellsTable[x + y * scene.gridWidth] = 0
                    else {
                        scene.cellsTable[x + y * scene.gridWidth] = scene.cellsTable[x + (y-1) * scene.gridWidth]
                        scene.cellsTable[x + y * scene.gridWidth].cellY++
                    }
                }
            }
        }

        Image {
            id: vplayLogo
            source: "../assets/vplay-logo.png"

            // 50px is the "logical size" of the image, based on the scene size 480x320
            // on hd or hd2 displays, it will be shown at 100px (hd) or 200px (hd2)
            // thus this image should be at least 200px big to look crisp on all resolutions
            // for more details, see here: http://v-play.net/doc/vplay-different-screen-sizes/
            width: 50
            height: 50

            // this positions it absolute right and top of the GameWindow
            // change resolutions with Ctrl (or Cmd on Mac) + the number keys 1-8 to see the effect
            anchors.right: scene.gameWindowAnchorItem.right
            anchors.top: scene.gameWindowAnchorItem.top

            // this animation sequence fades the V-Play logo in and out infinitely (by modifying its opacity property)
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                PropertyAnimation {
                    to: 0
                    duration: 1000 // 1 second for fade out
                }
                PropertyAnimation {
                    to: 1
                    duration: 1000 // 1 second for fade in
                }
            }
        }

    }
}
