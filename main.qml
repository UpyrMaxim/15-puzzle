import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.3
import custom.GemPuzzleModel 1.0

Window {
    id: root

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

        onYes: gemPuzzleModel.resetCells(gameBoard.dimentionX,gameBoard.dimentionY)
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
                onClicked: gemPuzzleModel.resetCells(gameBoard.dimentionX,gameBoard.dimentionY)
            }
        }


        Rectangle {
            id: gameBoard

            property int dimentionY: 4
            property int dimentionX: 4
            property var values: []

            y: 40
            x: 10
            width: parent.width - 20
            height: width + 20
            color: "#ffe4c4"

            GridView {
                id: view

                anchors.margins: 0
                anchors.fill: parent
                cellHeight: parent.height / gameBoard.dimentionY
                cellWidth: parent.width / gameBoard.dimentionX
                model: GemPuzzleModel{
                    id: gemPuzzleModel

                    Component.onCompleted: gemPuzzleModel.resetCells(gameBoard.dimentionX,gameBoard.dimentionY)
                }
                clip: true
                delegate: Item {
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
                        visible: display > 0

                        Text {
                            anchors.centerIn: parent
                            renderType: Text.NativeRendering
                            text: display | ""
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                view.currentIndex = model.index;
                                if (gemPuzzleModel.swapWithZeroIfPosible(display)) {
                                    if (gemPuzzleModel.checkComplete()) {
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
