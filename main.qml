import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.3
import "workScripts.js" as WorkScripts

Window {
    id: root
    visible: true
    width: 340
    height: width + 50
    title: qsTr("Hello World")

    Component.onCompleted: {
        setX(Screen.width / 2 - width / 2);
        setY(Screen.height / 2 - height / 2);
    }

    MessageDialog {
        id: messageDialog
        icon: StandardIcon.Information
        title: "Congratulation!!!"
        text: "The puzzle has been solved. Do you want to solve another one?"
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: {
            resetBoard(gameBoard.dementionX * gameBoard.dementionY);
        }
        onNo: console.log("presed no")
        Component.onCompleted: visible = false
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#deb887"

        Rectangle {
            y: 10
            x: parent.width - 20 - width
            width: 60
            height: 20
            radius: height / 2

            Text {
                x: 10
                text: "Reset"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                     resetBoard(gameBoard.dementionX * gameBoard.dementionY);
                }
            }
        }


        Rectangle {
            id: gameBoard
            y: 40
            x: 10
            width: parent.width - 20
            height: width + 20
            color: "#ffe4c4"
            property int dementionY: 4
            property int dementionX: 4
            property var values: []

            ListModel {
                id: cellsModel

                Component.onCompleted: {
                    gameBoard.values = WorkScripts.getShuffledValues(gameBoard.dementionX * gameBoard.dementionY);
                    gameBoard.values.forEach(element => append({value: element}));
                }
            }

            GridView {
                id: view
                anchors.margins: 0
                anchors.fill: parent
                cellHeight: parent.height / gameBoard.dementionY
                cellWidth: parent.width / gameBoard.dementionX
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

                                let swapResult = WorkScripts.swapWithZeroIfPosible(gameBoard.values, model.value, gameBoard.dementionX, gameBoard.dementionY);
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
                                        messageDialog.open();
                                    }
                                }
                            }
                        }
                    }
                }

                move: Transition {
                    id: moveTrans
                    SequentialAnimation {
                        NumberAnimation { properties: "x,y"; duration: 400;}
                    }
                }
            }
        }
    }

    function resetBoard(elementsCount)
    {
        cellsModel.clear()
        gameBoard.values = WorkScripts.getShuffledValues(elementsCount)
        gameBoard.values.forEach(element => cellsModel.append({value: element}));
    }
}
