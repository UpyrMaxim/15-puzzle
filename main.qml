import QtQuick 2.12
import QtQuick.Window 2.12
import "workScripts.js" as WorkScripts

Window {
    id: root
    visible: true
    width: 340
    height: 400
    title: qsTr("Hello World")

    Component.onCompleted: {
        setX(Screen.width / 2 - width / 2);
        setY(Screen.height / 2 - height / 2);
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#deb887"


        Rectangle {
            id: gameBoard
            y: 40
            x: 10
            width: parent.width - 20
            height: parent.width
            color: "#ffe4c4"

            property var values: []

            ListModel {
                id: cellsModel

                Component.onCompleted: {
                    gameBoard.values = WorkScripts.getShuffledValues(16);
                    gameBoard.values.forEach(element => append({value: element}));
                }
            }

            GridView {
                id: view
                anchors.margins: 0
                anchors.fill: parent
                cellHeight: parent.height / 4
                cellWidth: parent.width / 4
                model: cellsModel
                clip: true
                delegate: Item {
                    property var view: GridView.view
                    property var isCurrent: GridView.isCurrentItem

                    height: view.cellHeight
                    width: view.cellWidth

                    Rectangle {
                        anchors.margins: 5
                        anchors.fill: parent
                        border {
                            color: "black"
                            width: 1
                        }
                        visible: model.value > 0 ? true : false;

                        Text {
                            anchors.centerIn: parent
                            renderType: Text.NativeRendering
                            text: model.value
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                view.currentIndex = model.index
                                console.log("current " + gameBoard.values[index] + " index " + index)
                                let swapResult = WorkScripts.swapWithZeroIfPosible(gameBoard.values, model.value);
                                if(swapResult) { // if swap success
                                    let shift = 0;
                                    let currentPosition = index;
                                    [gameBoard.values, shift] = swapResult;
                                    cellsModel.move(view.currentIndex, view.currentIndex - shift, 1)
                                    if(Math.abs(shift) > 1) { // if bot or top swap
                                        if(shift > 0) {
                                            cellsModel.move(view.currentIndex - shift + 1, view.currentIndex, 1)
                                        } else {
                                            cellsModel.move(view.currentIndex - shift - 1, view.currentIndex, 1)
                                        }
                                    }
                                    if(WorkScripts.checkComplete(gameBoard.values)) {
                                        console.log("Congr");
                                        var component = Qt.createComponent("CongratWindow.qml")
                                        var window    = component.createObject(root)
                                        window.show()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

}
