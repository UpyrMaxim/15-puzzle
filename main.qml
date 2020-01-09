import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.3
import "workScripts.js" as WorkScripts

Window {
    id: root

    function resetBoard()
    {
        cellsModel.clear();
        gameBoard.values = WorkScripts.getShuffledValues(gameBoard.dementionX, gameBoard.dementionY);
        gameBoard.values.forEach(element => cellsModel.append({value: element}));
    }

    x: { Screen.width / 2 - width / 2 }
    y: { Screen.height / 2 - height / 2 }
    visible: true
    width: 340
    height: width + 50
    title: qsTr("Hello World")

    MessageDialog {
        id: messageDialog

        icon: StandardIcon.Information
        title: "Congratulation!!!"
        text: "The puzzle has been solved. Do you want to solve another one?"
        standardButtons: StandardButton.Yes | StandardButton.No
        visible: false

        onYes: {
            resetBoard();
        }
        onNo: console.log("presed no")
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
                onClicked: resetBoard()
            }
        }


        Rectangle {
            id: gameBoard

            property int dementionY: 4
            property int dementionX: 4
            property var values: []

            y: 40
            x: 10
            width: parent.width - 20
            height: width + 20
            color: "#ffe4c4"

            ListModel {
                id: cellsModel
                Component.onCompleted: resetBoard()
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
                        visible: model.value > 0

                        Text {
                            anchors.centerIn: parent
                            renderType: Text.NativeRendering
                            text: model.value
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                view.currentIndex = model.index;

                                let swapResult = WorkScripts.swapWithZeroIfPosible(gameBoard.values, model.value, gameBoard.dementionX, gameBoard.dementionY);
                                if (swapResult) { // if swap success
                                    let shift = 0;
                                    let currentPosition = index;
                                    [gameBoard.values, shift] = swapResult;
                                    cellsModel.move(view.currentIndex, view.currentIndex - shift, 1);
                                    if (Math.abs(shift) > 1) { // if bot or top swap
                                        shift = shift > 0 ? shift - 1 : shift + 1;
                                        cellsModel.move(view.currentIndex - shift, view.currentIndex, 1);
                                    }
                                    if (WorkScripts.checkComplete(gameBoard.values)) {
                                        messageDialog.open();
                                    }
                                }
                            }
                        }
                    }
                }

                move: Transition {
                    SequentialAnimation {
                        NumberAnimation { properties: "x,y"; duration: 400;}
                    }
                }
            }
        }
    }
}
